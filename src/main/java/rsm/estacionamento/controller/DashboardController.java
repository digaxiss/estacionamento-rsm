package rsm.estacionamento.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import rsm.estacionamento.model.Movimentacao;
import rsm.estacionamento.model.Veiculo;
import rsm.estacionamento.util.ConexaoDB;

/**
 * Servlet responsável pelo dashboard principal do sistema
 * Exibe estatísticas e informações gerais sobre o estacionamento
 */
@WebServlet({"/", "/dashboard"})  // Mapeia tanto a raiz quanto /dashboard para este servlet
public class DashboardController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("DashboardController: Processando requisição de dashboard - URI: " + request.getRequestURI());
        
        try {
            // Busca informações para exibir no dashboard
            int totalVagas = obterTotalVagas();
            int vagasOcupadas = obterVagasOcupadas();
            int vagasDisponiveis = totalVagas - vagasOcupadas;
            
            BigDecimal faturamentoHoje = obterFaturamentoHoje();
            BigDecimal totalSemana = obterFaturamentoSemana();
            BigDecimal totalMes = obterFaturamentoMes();
            BigDecimal ticketMedio = calcularTicketMedio();
            
            List<Veiculo> veiculosEstacionados = obterVeiculosEstacionados();
            List<Movimentacao> ultimasMovimentacoes = obterUltimasMovimentacoes();
            
            // Atribuir informações ao request para exibição no JSP
            request.setAttribute("totalVagas", totalVagas);
            request.setAttribute("vagasOcupadas", vagasOcupadas);
            request.setAttribute("vagasDisponiveis", vagasDisponiveis);
            
            request.setAttribute("faturamentoHoje", faturamentoHoje.setScale(2, RoundingMode.HALF_UP));
            request.setAttribute("totalSemana", totalSemana.setScale(2, RoundingMode.HALF_UP));
            request.setAttribute("totalMes", totalMes.setScale(2, RoundingMode.HALF_UP));
            request.setAttribute("ticketMedio", ticketMedio.setScale(2, RoundingMode.HALF_UP));
            
            request.setAttribute("veiculosEstacionados", veiculosEstacionados);
            request.setAttribute("ultimasMovimentacoes", ultimasMovimentacoes);
            
            // Encaminha para a página do dashboard
            try {
                System.out.println("Tentando carregar dashboard.jsp...");
                request.getRequestDispatcher("/WEB-INF/view/dashboard.jsp").forward(request, response);
            } catch (Exception e) {
                System.err.println("Erro ao carregar dashboard.jsp: " + e.getMessage());
                e.printStackTrace();
                response.setContentType("text/html");
                response.getWriter().print("<html><body>");
                response.getWriter().print("<h1>Erro ao carregar dashboard</h1>");
                response.getWriter().print("<p>" + e.getMessage() + "</p>");
                response.getWriter().print("<pre>");
                e.printStackTrace(new java.io.PrintWriter(response.getWriter()));
                response.getWriter().print("</pre>");
                response.getWriter().print("</body></html>");
            }
            
        } catch (SQLException e) {
            // Log do erro
            System.err.println("Erro ao carregar dados do dashboard: " + e.getMessage());
            e.printStackTrace();
            
            // Resposta de erro para depuração
            response.setContentType("text/html");
            response.getWriter().println("<html><body>");
            response.getWriter().println("<h1>Erro ao carregar dados do dashboard</h1>");
            response.getWriter().println("<p>Erro: " + e.getMessage() + "</p>");
            response.getWriter().println("<h3>Stack Trace:</h3>");
            response.getWriter().println("<pre>");
            e.printStackTrace(new java.io.PrintWriter(response.getWriter()));
            response.getWriter().println("</pre>");
            response.getWriter().println("<a href='" + request.getContextPath() + "/login'>Voltar para login</a>");
            response.getWriter().println("</body></html>");
        }
    }
    
    /**
     * Obtém o número total de vagas configurado no sistema
     */
    private int obterTotalVagas() throws SQLException {
        String sql = "SELECT valor FROM configuracoes WHERE chave = 'total_vagas'";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("valor");
            }
        }
        
        return 30; // Valor padrão
    }
    
    /**
     * Obtém o número de vagas ocupadas atualmente
     */
    private int obterVagasOcupadas() throws SQLException {
        String sql = "SELECT COUNT(*) AS ocupadas FROM veiculos_estacionados WHERE saida IS NULL";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("ocupadas");
            }
        }
        
        return 0;
    }
    
    /**
     * Obtém o faturamento do dia atual
     */
    private BigDecimal obterFaturamentoHoje() throws SQLException {
        String sql = "SELECT COALESCE(SUM(valor_pago), 0) AS total FROM veiculos_estacionados " +
                     "WHERE DATE(saida) = CURRENT_DATE";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Obtém o faturamento da semana atual
     */
    private BigDecimal obterFaturamentoSemana() throws SQLException {
        String sql = "SELECT COALESCE(SUM(valor_pago), 0) AS total FROM veiculos_estacionados " +
                     "WHERE saida >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Obtém o faturamento do mês atual
     */
    private BigDecimal obterFaturamentoMes() throws SQLException {
        String sql = "SELECT COALESCE(SUM(valor_pago), 0) AS total FROM veiculos_estacionados " +
                     "WHERE MONTH(saida) = MONTH(CURRENT_DATE) AND YEAR(saida) = YEAR(CURRENT_DATE)";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Calcula o ticket médio (valor médio por veículo)
     */
    private BigDecimal calcularTicketMedio() throws SQLException {
        String sql = "SELECT COALESCE(AVG(valor_pago), 0) AS media FROM veiculos_estacionados " +
                     "WHERE saida IS NOT NULL AND saida >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getBigDecimal("media");
            }
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Obtém a lista de veículos atualmente estacionados
     */
    private List<Veiculo> obterVeiculosEstacionados() throws SQLException {
        List<Veiculo> veiculos = new ArrayList<>();
        
        String sql = "SELECT id, placa, tipo_veiculo, entrada, observacoes FROM veiculos_estacionados " +
                     "WHERE saida IS NULL ORDER BY entrada DESC LIMIT 10";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Veiculo veiculo = new Veiculo();
                veiculo.setId(rs.getInt("id"));
                veiculo.setPlaca(rs.getString("placa"));
                veiculo.setTipoVeiculo(rs.getString("tipo_veiculo"));
                veiculo.setObservacoes(rs.getString("observacoes"));
                
                // Obtém a data/hora de entrada e calcula o tempo de permanência
                LocalDateTime dataEntrada = rs.getTimestamp("entrada").toLocalDateTime();
                veiculo.setDataEntrada(dataEntrada);
                
                // Calcula o tempo de permanência
                Duration duracao = Duration.between(dataEntrada, LocalDateTime.now());
                long horas = duracao.toHours();
                long minutos = duracao.toMinutesPart();
                veiculo.setTempoPermanencia(horas + "h " + minutos + "min");
                
                // Calcula o valor atual a pagar
                BigDecimal valorAtual = calcularValorAtual(dataEntrada);
                veiculo.setValorAtual(valorAtual.toString().replace('.', ','));
                
                veiculos.add(veiculo);
            }
        }
        
        return veiculos;
    }
    
    /**
     * Calcula o valor atual a ser pago com base no tempo de permanência
     */
    private BigDecimal calcularValorAtual(LocalDateTime dataEntrada) {
        LocalDateTime agora = LocalDateTime.now();
        Duration duracao = Duration.between(dataEntrada, agora);
        
        // Obtém o total de horas, arredondando para cima se houver minutos
        long horasTotal = duracao.toHours();
        if (duracao.toMinutesPart() > 0) {
            horasTotal++;
        }
        
        BigDecimal valorPrimeiraHora = new BigDecimal("25.00");
        BigDecimal valorHoraAdicional = new BigDecimal("9.00");
        
        BigDecimal valorTotal;
        if (horasTotal <= 1) {
            valorTotal = valorPrimeiraHora;
        } else {
            valorTotal = valorPrimeiraHora.add(valorHoraAdicional.multiply(new BigDecimal(horasTotal - 1)));
        }
        
        return valorTotal.setScale(2, RoundingMode.HALF_UP);
    }
    
    /**
     * Obtém as últimas movimentações (entradas e saídas)
     */
    private List<Movimentacao> obterUltimasMovimentacoes() throws SQLException {
        List<Movimentacao> movimentacoes = new ArrayList<>();
        
        // SQL para obter as últimas movimentações, incluindo entradas e saídas
        String sql = "SELECT id, placa, tipo_veiculo, entrada, saida, valor_pago, forma_pagamento " +
                     "FROM veiculos_estacionados " +
                     "ORDER BY COALESCE(saida, entrada) DESC LIMIT 10";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Movimentacao mov = new Movimentacao();
                mov.setId(rs.getInt("id"));
                mov.setPlaca(rs.getString("placa"));
                mov.setTipoVeiculo(rs.getString("tipo_veiculo"));
                
                // Define data e hora de entrada
                mov.setDataEntrada(rs.getTimestamp("entrada").toLocalDateTime());
                
                // Define data e hora de saída (se houver)
                if (rs.getTimestamp("saida") != null) {
                    mov.setDataSaida(rs.getTimestamp("saida").toLocalDateTime());
                    mov.setValorPago(rs.getBigDecimal("valor_pago"));
                    mov.setFormaPagamento(rs.getString("forma_pagamento"));
                }
                
                movimentacoes.add(mov);
            }
        }
        
        return movimentacoes;
    }
}
