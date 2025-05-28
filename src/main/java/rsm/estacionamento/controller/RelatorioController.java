package rsm.estacionamento.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import rsm.estacionamento.model.Movimentacao;
import rsm.estacionamento.util.ConexaoDB;
import rsm.estacionamento.util.LogUtil;

/**
 * Servlet responsável pela geração de relatórios de movimentação e faturamento
 */
@WebServlet("/relatorio")
public class RelatorioController extends HttpServlet {
    
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter MONTH_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM");
    private static final DateTimeFormatter DISPLAY_DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter DISPLAY_MONTH_FORMATTER = DateTimeFormatter.ofPattern("MMMM/yyyy");
    
    /**
     * Exibe a página de relatórios com os dados filtrados
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Obter tipo de filtro selecionado (diário, semanal, mensal)
            String tipoFiltro = request.getParameter("tipoFiltro");
            if (tipoFiltro == null || tipoFiltro.isEmpty()) {
                tipoFiltro = "diario"; // Default: relatório diário
            }
            
            LocalDate dataInicio = null;
            LocalDate dataFim = null;
            String periodoFormatado = "";

            // Processar os parâmetros conforme o tipo de filtro
            switch (tipoFiltro) {
                case "diario":
                    String dataDiaria = request.getParameter("dataDiaria");
                    LocalDate dataDiariaObj = dataDiaria != null && !dataDiaria.isEmpty() 
                                            ? LocalDate.parse(dataDiaria) 
                                            : LocalDate.now();
                    
                    dataInicio = dataDiariaObj;
                    dataFim = dataDiariaObj;
                    
                    periodoFormatado = "(diário) dia " + dataInicio.format(DISPLAY_DATE_FORMATTER) + 
                                      " - valor total recebido no dia R$ ";
                    request.setAttribute("dataDiaria", dataDiariaObj.format(DATE_FORMATTER));
                    break;
                    
                case "semanal":
                    String dataSemanal = request.getParameter("dataSemanal");
                    LocalDate dataSemanalObj = dataSemanal != null && !dataSemanal.isEmpty() 
                                             ? LocalDate.parse(dataSemanal) 
                                             : LocalDate.now();
                    
                    // A data fim é a data selecionada, a data início é 6 dias antes (total 7 dias)
                    dataFim = dataSemanalObj;
                    dataInicio = dataFim.minusDays(6);
                    
                    periodoFormatado = "(semanal) periodo entre " + dataInicio.format(DISPLAY_DATE_FORMATTER) + 
                                      " e " + dataFim.format(DISPLAY_DATE_FORMATTER) + 
                                      " valor total recebido neste periodo: R$ ";
                    request.setAttribute("dataSemanal", dataSemanalObj.format(DATE_FORMATTER));
                    break;
                    
                case "mensal":
                    String dataMensal = request.getParameter("dataMensal");
                    YearMonth mesAno;
                    
                    if (dataMensal != null && !dataMensal.isEmpty()) {
                        mesAno = YearMonth.parse(dataMensal);
                    } else {
                        mesAno = YearMonth.now();
                    }
                    
                    // Primeiro e último dia do mês selecionado
                    dataInicio = mesAno.atDay(1);
                    dataFim = mesAno.atEndOfMonth();
                    
                    periodoFormatado = "(mensal) periodo entre " + dataInicio.format(DISPLAY_DATE_FORMATTER) + 
                                      " e " + dataFim.format(DISPLAY_DATE_FORMATTER) + 
                                      " – valor total recebido neste periodo: R$ ";
                    request.setAttribute("dataMensal", mesAno.format(MONTH_FORMATTER));
                    break;
            }

            // Busca movimentações do período
            List<Movimentacao> movimentacoes = buscarMovimentacoes(dataInicio, dataFim);
            double totalValor = calcularTotalValor(movimentacoes);
            
            // Atributos para o JSP
            request.setAttribute("tipoFiltro", tipoFiltro);
            request.setAttribute("movimentacoes", movimentacoes);
            request.setAttribute("totalValor", String.format("%.2f", totalValor).replace('.', ','));
            request.setAttribute("totalMovimentacoes", movimentacoes.size());
            request.setAttribute("periodoFormatado", periodoFormatado + String.format("%.2f", totalValor).replace('.', ','));
            
            LogUtil.info("RelatorioController", "Relatório " + tipoFiltro + " gerado para o período de " + 
                        dataInicio.format(DATE_FORMATTER) + " a " + dataFim.format(DATE_FORMATTER));
            
        } catch (Exception e) {
            // Log do erro
            LogUtil.error("RelatorioController", "Erro ao processar relatório", e);
            
            // Exibe mensagem de erro
            request.setAttribute("mensagemErro", "Erro ao buscar dados para o relatório: " + e.getMessage());
        }
        
        // Encaminha para a página de relatórios
        request.getRequestDispatcher("/WEB-INF/view/relatorio.jsp").forward(request, response);
    }
    
    /**
     * Calcula o valor total das movimentações
     */
    private double calcularTotalValor(List<Movimentacao> movimentacoes) {
        double totalValor = 0.0;
        for (Movimentacao m : movimentacoes) {
            if (m.getValorPago() != null) {
                totalValor += m.getValorPago().doubleValue();
            }
        }
        return totalValor;
    }
    
    /**
     * Busca as movimentações do estacionamento para um período específico
     * @param dataInicio Data inicial do período
     * @param dataFim Data final do período
     * @return Lista de movimentações
     * @throws SQLException Em caso de erro no banco de dados
     */
    private List<Movimentacao> buscarMovimentacoes(LocalDate dataInicio, LocalDate dataFim) throws SQLException {
        List<Movimentacao> movimentacoes = new ArrayList<>();
        
        // Ajustando as datas para incluir todo o período (início às 00:00:00 e fim às 23:59:59)
        LocalDateTime inicioDia = dataInicio.atStartOfDay();
        LocalDateTime fimDia = dataFim.plusDays(1).atStartOfDay().minusSeconds(1);
        
        // SQL para buscar movimentações com saídas registradas no período (para calcular faturamento)
        String sql = "SELECT id, placa, tipo_veiculo, entrada, saida, valor_pago, forma_pagamento, observacoes " +
                     "FROM veiculos_estacionados " +
                     "WHERE saida IS NOT NULL AND saida BETWEEN ? AND ? " +
                     "ORDER BY saida DESC";
        
        try (Connection conn = ConexaoDB.obterConexao();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setObject(1, inicioDia);
            stmt.setObject(2, fimDia);
            
            LogUtil.info("RelatorioController", "Executando SQL: " + sql + " [" + inicioDia + ", " + fimDia + "]");
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Movimentacao mov = new Movimentacao();
                    mov.setId(rs.getInt("id"));
                    mov.setPlaca(rs.getString("placa"));
                    mov.setTipoVeiculo(rs.getString("tipo_veiculo"));
                    
                    // Converte timestamp para LocalDateTime
                    if (rs.getTimestamp("entrada") != null) {
                        mov.setDataEntrada(rs.getTimestamp("entrada").toLocalDateTime());
                    }
                    
                    if (rs.getTimestamp("saida") != null) {
                        mov.setDataSaida(rs.getTimestamp("saida").toLocalDateTime());
                    }
                    
                    mov.setValorPago(rs.getBigDecimal("valor_pago"));
                    mov.setFormaPagamento(rs.getString("forma_pagamento"));
                    mov.setObservacoes(rs.getString("observacoes"));
                    
                    movimentacoes.add(mov);
                }
            }
        }
        
        return movimentacoes;
    }
}
