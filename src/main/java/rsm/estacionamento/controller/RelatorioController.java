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
import java.time.temporal.ChronoUnit;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import rsm.estacionamento.model.Movimentacao;
import rsm.estacionamento.model.RelatorioEstatisticas;
import rsm.estacionamento.util.ConexaoDB;

/**
 * Servlet responsável pela geração de relatórios de movimentação com
 * estatísticas avançadas
 */
@WebServlet("/relatorio")
public class RelatorioController extends HttpServlet {

    private static final int CAPACIDADE_ESTACIONAMENTO = 100; // Configurável

    /**
     * Exibe a página de relatórios com os dados filtrados
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Parâmetros de filtro
        String tipoFiltro = request.getParameter("tipoFiltro");
        String dataInicio = request.getParameter("dataInicio");
        String dataFim = request.getParameter("dataFim");

        // Define valores padrão
        if (tipoFiltro == null || tipoFiltro.trim().isEmpty()) {
            tipoFiltro = "diario";
        }

        try {
            // Calcula datas baseado no tipo de filtro
            LocalDate[] periodo = calcularPeriodo(tipoFiltro, dataInicio, dataFim);
            LocalDate dataInicioCalc = periodo[0];
            LocalDate dataFimCalc = periodo[1];

            // Busca movimentações do período
            List<Movimentacao> movimentacoes = buscarMovimentacoesPorPeriodo(dataInicioCalc, dataFimCalc);

            // Calcula estatísticas
            RelatorioEstatisticas stats = RelatorioEstatisticas.calcular(
                    movimentacoes, tipoFiltro, CAPACIDADE_ESTACIONAMENTO);

            // Busca dados adicionais para gráficos
            Map<String, Object> dadosGraficos = buscarDadosGraficos(dataInicioCalc, dataFimCalc, tipoFiltro);

            // Define atributos para JSP
            request.setAttribute("movimentacoes", movimentacoes);
            request.setAttribute("estatisticas", stats);
            request.setAttribute("tipoFiltro", tipoFiltro);
            request.setAttribute("dataInicio", dataInicioCalc.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
            request.setAttribute("dataFim", dataFimCalc.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
            request.setAttribute("dadosGraficos", dadosGraficos);

            // Compatibilidade com JSP existente
            request.setAttribute("totalVeiculos", stats.getTotalVeiculos());
            request.setAttribute("totalValor", stats.getFaturamentoTotal().doubleValue());
            request.setAttribute("veiculosCompletos", stats.getVeiculosCompletos());
            request.setAttribute("veiculosEmAberto", stats.getVeiculosEmAberto());
            request.setAttribute("mediaDiaria", stats.getMediaDiaria().doubleValue());
            request.setAttribute("percentualOcupacao", stats.getPercentualOcupacao());

        } catch (SQLException e) {
            // Log do erro
            System.err.println("Erro ao buscar movimentações: " + e.getMessage());
            e.printStackTrace();

            // Exibe mensagem de erro
            request.setAttribute("mensagemErro", "Erro ao buscar dados para o relatório: " + e.getMessage());
        }

        // Encaminha para a página de relatórios
        request.getRequestDispatcher("/WEB-INF/view/relatorio.jsp").forward(request, response);
    }

    /**
     * Calcula o período baseado no tipo de filtro
     */
    private LocalDate[] calcularPeriodo(String tipoFiltro, String dataInicio, String dataFim) {
        LocalDate hoje = LocalDate.now();
        LocalDate inicio, fim;

        switch (tipoFiltro) {
            case "semanal":
                // Semana atual (Segunda a Domingo)
                inicio = hoje.with(TemporalAdjusters.previousOrSame(java.time.DayOfWeek.MONDAY));
                fim = inicio.plusDays(6);
                break;

            case "mensal":
                // Mês atual
                inicio = hoje.with(TemporalAdjusters.firstDayOfMonth());
                fim = hoje.with(TemporalAdjusters.lastDayOfMonth());
                break;

            case "personalizado":
                // Período personalizado
                try {
                inicio = dataInicio != null && !dataInicio.isEmpty()
                        ? LocalDate.parse(dataInicio) : hoje.minusDays(7);
                fim = dataFim != null && !dataFim.isEmpty()
                        ? LocalDate.parse(dataFim) : hoje;

                // Garante que início não seja posterior ao fim
                if (inicio.isAfter(fim)) {
                    LocalDate temp = inicio;
                    inicio = fim;
                    fim = temp;
                }
            } catch (Exception e) {
                System.err.println("Erro ao parsear datas personalizadas: " + e.getMessage());
                inicio = hoje.minusDays(7);
                fim = hoje;
            }
            break;

            default: // diario
                inicio = hoje;
                fim = hoje;
                break;
        }

        return new LocalDate[]{inicio, fim};
    }

    /**
     * Busca dados para gráficos e análises adicionais
     */
    private Map<String, Object> buscarDadosGraficos(LocalDate dataInicio, LocalDate dataFim, String tipoFiltro)
            throws SQLException {
        Map<String, Object> dados = new HashMap<>();

        // Movimentação por tipo de veículo
        dados.put("porTipoVeiculo", buscarMovimentacaoPorTipo(dataInicio, dataFim));

        // Faturamento por dia (para gráfico de linha)
        dados.put("faturamentoDiario", buscarFaturamentoDiario(dataInicio, dataFim));

        // Horários de pico
        dados.put("horariosPico", buscarHorariosPico(dataInicio, dataFim));

        // Formas de pagamento
        dados.put("formasPagamento", buscarFormasPagamento(dataInicio, dataFim));

        return dados;
    }

    /**
     * Busca movimentação por tipo de veículo
     */
    private Map<String, Integer> buscarMovimentacaoPorTipo(LocalDate dataInicio, LocalDate dataFim)
            throws SQLException {
        Map<String, Integer> resultado = new HashMap<>();

        String sql = "SELECT tipo_veiculo, COUNT(*) as quantidade "
                + "FROM veiculos_estacionados "
                + "WHERE DATE(entrada) BETWEEN ? AND ? "
                + "GROUP BY tipo_veiculo "
                + "ORDER BY quantidade DESC";

        try (Connection conn = ConexaoDB.obterConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, dataInicio.toString());
            stmt.setString(2, dataFim.toString());

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    resultado.put(rs.getString("tipo_veiculo"), rs.getInt("quantidade"));
                }
            }
        }

        return resultado;
    }

    /**
     * Busca faturamento diário para gráfico
     */
    private Map<String, Double> buscarFaturamentoDiario(LocalDate dataInicio, LocalDate dataFim)
            throws SQLException {
        Map<String, Double> resultado = new HashMap<>();

        String sql = "SELECT DATE(entrada) as data, COALESCE(SUM(valor_pago), 0) as faturamento "
                + "FROM veiculos_estacionados "
                + "WHERE DATE(entrada) BETWEEN ? AND ? "
                + "GROUP BY DATE(entrada) "
                + "ORDER BY data";

        try (Connection conn = ConexaoDB.obterConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, dataInicio.toString());
            stmt.setString(2, dataFim.toString());

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String data = rs.getString("data");
                    Double faturamento = rs.getDouble("faturamento");
                    resultado.put(data, faturamento);
                }
            }
        }

        return resultado;
    }

    /**
     * Busca horários de pico (entrada por hora)
     */
    private Map<Integer, Integer> buscarHorariosPico(LocalDate dataInicio, LocalDate dataFim)
            throws SQLException {
        Map<Integer, Integer> resultado = new HashMap<>();

        String sql = "SELECT HOUR(entrada) as hora, COUNT(*) as quantidade "
                + "FROM veiculos_estacionados "
                + "WHERE DATE(entrada) BETWEEN ? AND ? "
                + "GROUP BY HOUR(entrada) "
                + "ORDER BY hora";

        try (Connection conn = ConexaoDB.obterConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, dataInicio.toString());
            stmt.setString(2, dataFim.toString());

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    resultado.put(rs.getInt("hora"), rs.getInt("quantidade"));
                }
            }
        }

        return resultado;
    }

    /**
     * Busca distribuição por formas de pagamento
     */
    private Map<String, Integer> buscarFormasPagamento(LocalDate dataInicio, LocalDate dataFim)
            throws SQLException {
        Map<String, Integer> resultado = new HashMap<>();

        String sql = "SELECT COALESCE(forma_pagamento, 'Não Informado') as forma, COUNT(*) as quantidade "
                + "FROM veiculos_estacionados "
                + "WHERE DATE(entrada) BETWEEN ? AND ? AND valor_pago IS NOT NULL "
                + "GROUP BY forma_pagamento "
                + "ORDER BY quantidade DESC";

        try (Connection conn = ConexaoDB.obterConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, dataInicio.toString());
            stmt.setString(2, dataFim.toString());

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    resultado.put(rs.getString("forma"), rs.getInt("quantidade"));
                }
            }
        }

        return resultado;
    }

    /**
     * Busca as movimentações do estacionamento para um período específico
     */
    private List<Movimentacao> buscarMovimentacoesPorPeriodo(LocalDate dataInicio, LocalDate dataFim)
            throws SQLException {
        List<Movimentacao> movimentacoes = new ArrayList<>();

        String sql = "SELECT id, placa, tipo_veiculo, entrada, saida, valor_pago, forma_pagamento, observacoes "
                + "FROM veiculos_estacionados "
                + "WHERE DATE(entrada) BETWEEN ? AND ? "
                + "ORDER BY entrada DESC";

        try (Connection conn = ConexaoDB.obterConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, dataInicio.toString());
            stmt.setString(2, dataFim.toString());

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
