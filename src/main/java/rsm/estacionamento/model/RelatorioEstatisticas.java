package rsm.estacionamento.model;

import java.math.BigDecimal;
import java.util.List;

/**
 * Classe para cálculos estatísticos de relatórios
 */
public class RelatorioEstatisticas {

    private int totalVeiculos;
    private int veiculosCompletos;
    private int veiculosEmAberto;
    private int veiculosSemPagamento;
    private BigDecimal faturamentoTotal;
    private BigDecimal ticketMedio;
    private BigDecimal mediaDiaria;
    private double percentualOcupacao;
    private String periodoDescricao;

    /**
     * Calcula estatísticas baseadas na lista de movimentações
     */
    public static RelatorioEstatisticas calcular(List<Movimentacao> movimentacoes, String tipoFiltro, int capacidadeEstacionamento) {
        RelatorioEstatisticas stats = new RelatorioEstatisticas();

        stats.totalVeiculos = movimentacoes.size();
        stats.faturamentoTotal = BigDecimal.ZERO;
        stats.veiculosCompletos = 0;
        stats.veiculosEmAberto = 0;
        stats.veiculosSemPagamento = 0;

        // Processa cada movimentação
        for (Movimentacao mov : movimentacoes) {
            // Soma faturamento
            if (mov.getValorPago() != null) {
                stats.faturamentoTotal = stats.faturamentoTotal.add(mov.getValorPago());
            }

            // Classifica status
            if (mov.getDataSaida() != null) {
                if (mov.getValorPago() != null) {
                    stats.veiculosCompletos++;
                } else {
                    stats.veiculosSemPagamento++;
                }
            } else {
                stats.veiculosEmAberto++;
            }
        }

        // Calcula ticket médio
        if (stats.totalVeiculos > 0) {
            stats.ticketMedio = stats.faturamentoTotal.divide(
                    BigDecimal.valueOf(stats.totalVeiculos), 2, BigDecimal.ROUND_HALF_UP);
        } else {
            stats.ticketMedio = BigDecimal.ZERO;
        }

        // Calcula média diária baseada no tipo de filtro
        stats.mediaDiaria = calcularMediaDiaria(stats.faturamentoTotal, tipoFiltro);

        // Calcula percentual de ocupação
        if (capacidadeEstacionamento > 0) {
            stats.percentualOcupacao = Math.min(
                    (double) stats.totalVeiculos / capacidadeEstacionamento * 100, 100.0);
        }

        // Define descrição do período
        stats.periodoDescricao = obterDescricaoPeriodo(tipoFiltro);

        return stats;
    }

    /**
     * Calcula média diária baseada no tipo de filtro
     */
    private static BigDecimal calcularMediaDiaria(BigDecimal faturamentoTotal, String tipoFiltro) {
        switch (tipoFiltro) {
            case "semanal":
                return faturamentoTotal.divide(BigDecimal.valueOf(7), 2, BigDecimal.ROUND_HALF_UP);
            case "mensal":
                // Aproximação de 30 dias por mês
                return faturamentoTotal.divide(BigDecimal.valueOf(30), 2, BigDecimal.ROUND_HALF_UP);
            case "personalizado":
                // Para período personalizado, retorna o total (seria necessário calcular dias)
                return faturamentoTotal;
            default: // diario
                return faturamentoTotal;
        }
    }

    /**
     * Obtém descrição do período para exibição
     */
    private static String obterDescricaoPeriodo(String tipoFiltro) {
        switch (tipoFiltro) {
            case "semanal":
                return "Relatório Semanal";
            case "mensal":
                return "Relatório Mensal";
            case "personalizado":
                return "Período Personalizado";
            default:
                return "Relatório Diário";
        }
    }

    // Getters e Setters
    public int getTotalVeiculos() {
        return totalVeiculos;
    }

    public void setTotalVeiculos(int totalVeiculos) {
        this.totalVeiculos = totalVeiculos;
    }

    public int getVeiculosCompletos() {
        return veiculosCompletos;
    }

    public void setVeiculosCompletos(int veiculosCompletos) {
        this.veiculosCompletos = veiculosCompletos;
    }

    public int getVeiculosEmAberto() {
        return veiculosEmAberto;
    }

    public void setVeiculosEmAberto(int veiculosEmAberto) {
        this.veiculosEmAberto = veiculosEmAberto;
    }

    public int getVeiculosSemPagamento() {
        return veiculosSemPagamento;
    }

    public void setVeiculosSemPagamento(int veiculosSemPagamento) {
        this.veiculosSemPagamento = veiculosSemPagamento;
    }

    public BigDecimal getFaturamentoTotal() {
        return faturamentoTotal;
    }

    public void setFaturamentoTotal(BigDecimal faturamentoTotal) {
        this.faturamentoTotal = faturamentoTotal;
    }

    public BigDecimal getTicketMedio() {
        return ticketMedio;
    }

    public void setTicketMedio(BigDecimal ticketMedio) {
        this.ticketMedio = ticketMedio;
    }

    public BigDecimal getMediaDiaria() {
        return mediaDiaria;
    }

    public void setMediaDiaria(BigDecimal mediaDiaria) {
        this.mediaDiaria = mediaDiaria;
    }

    public double getPercentualOcupacao() {
        return percentualOcupacao;
    }

    public void setPercentualOcupacao(double percentualOcupacao) {
        this.percentualOcupacao = percentualOcupacao;
    }

    public String getPeriodoDescricao() {
        return periodoDescricao;
    }

    public void setPeriodoDescricao(String periodoDescricao) {
        this.periodoDescricao = periodoDescricao;
    }

    /**
     * Formata o faturamento total para exibição
     */
    public String getFaturamentoTotalFormatado() {
        if (faturamentoTotal == null) {
            return "R$ 0,00";
        }
        return String.format("R$ %.2f", faturamentoTotal);
    }

    /**
     * Formata o ticket médio para exibição
     */
    public String getTicketMedioFormatado() {
        if (ticketMedio == null) {
            return "R$ 0,00";
        }
        return String.format("R$ %.2f", ticketMedio);
    }

    /**
     * Formata a média diária para exibição
     */
    public String getMediaDiariaFormatada() {
        if (mediaDiaria == null) {
            return "R$ 0,00";
        }
        return String.format("R$ %.2f", mediaDiaria);
    }

    /**
     * Retorna o percentual de ocupação formatado
     */
    public String getPercentualOcupacaoFormatado() {
        return String.format("%.1f%%", percentualOcupacao);
    }
}
