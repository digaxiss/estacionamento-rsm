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
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import rsm.estacionamento.model.Movimentacao;
import rsm.estacionamento.util.ConexaoDB;

/**
 * Servlet responsável pela geração de relatórios de movimentação
 */
@WebServlet("/relatorio")
public class RelatorioController extends HttpServlet {
    
    /**
     * Exibe a página de relatórios com os dados filtrados
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Obtém a data atual como padrão para o filtro
        LocalDate hoje = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        String dataFiltro = hoje.format(formatter);
        
        // Verifica se foi passado um filtro de data
        String dataParam = request.getParameter("data");
        if (dataParam != null && !dataParam.trim().isEmpty()) {
            dataFiltro = dataParam;
        }
        
        try {
            // Busca movimentações do dia
            List<Movimentacao> movimentacoes = buscarMovimentacoes(dataFiltro);
            request.setAttribute("movimentacoes", movimentacoes);
            request.setAttribute("dataFiltro", dataFiltro);
            
            // Calcula totais
            double totalValor = 0.0;
            for (Movimentacao m : movimentacoes) {
                if (m.getValorPago() != null) {
                    totalValor += m.getValorPago().doubleValue();
                }
            }
            request.setAttribute("totalValor", totalValor);
            request.setAttribute("totalMovimentacoes", movimentacoes.size());
            
        } catch (SQLException e) {
            // Log do erro
            System.err.println("Erro ao buscar movimentações: " + e.getMessage());
            
            // Exibe mensagem de erro
            request.setAttribute("mensagemErro", "Erro ao buscar dados para o relatório.");
        }
        
        // Encaminha para a página de relatórios
        request.getRequestDispatcher("/WEB-INF/view/relatorio.jsp").forward(request, response);
    }
    
    /**
     * Busca as movimentações do estacionamento para uma data específica
     * @param data Data para filtro (formato yyyy-MM-dd)
     * @return Lista de movimentações
     * @throws SQLException Em caso de erro no banco de dados
     */
    private List<Movimentacao> buscarMovimentacoes(String data) throws SQLException {
        List<Movimentacao> movimentacoes = new ArrayList<>();
        
        // Filtro para buscar movimentações na data especificada
        String sql = "SELECT id, placa, tipo_veiculo, entrada, saida, valor_pago, forma_pagamento, observacoes " + "FROM veiculos_estacionados " + "WHERE DATE(entrada) = ? " + "ORDER BY entrada DESC";
        
        try (Connection conn = ConexaoDB.obterConexao();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, data);
            
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
