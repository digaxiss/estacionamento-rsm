package rsm.estacionamento.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Classe que representa uma movimentação completa de veículo (entrada e saída)
 * Usada principalmente para relatórios
 */
public class Movimentacao {
    private int id;
    private String placa;
    private String tipoVeiculo;
    private LocalDateTime dataEntrada;
    private LocalDateTime dataSaida;
    private BigDecimal valorPago;
    private String formaPagamento;
    private String observacoes;
    
    /**
     * Construtor padrão
     */
    public Movimentacao() {
    }
    
    /**
     * Formata a data de entrada para exibição
     * @return Data formatada como string
     */
    public String getDataEntradaFormatada() {
        if (dataEntrada == null) return "";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return dataEntrada.format(formatter);
    }
    
    /**
     * Formata a hora de entrada para exibição
     * @return Hora formatada como string
     */
    public String getHoraEntradaFormatada() {
        if (dataEntrada == null) return "";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
        return dataEntrada.format(formatter);
    }
    
    /**
     * Formata a hora de saída para exibição
     * @return Hora formatada como string
     */
    public String getHoraSaidaFormatada() {
        if (dataSaida == null) return "";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
        return dataSaida.format(formatter);
    }
    
    /**
     * Formata o valor pago para exibição
     * @return Valor formatado como string
     */
    public String getValorPagoFormatado() {
        if (valorPago == null) return "";
        return String.format("R$%.2f", valorPago);
    }
    
    // Getters e Setters
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getPlaca() {
        return placa;
    }
    
    public void setPlaca(String placa) {
        this.placa = placa;
    }
    
    public String getTipoVeiculo() {
        return tipoVeiculo;
    }
    
    public void setTipoVeiculo(String tipoVeiculo) {
        this.tipoVeiculo = tipoVeiculo;
    }
    
    public LocalDateTime getDataEntrada() {
        return dataEntrada;
    }
    
    public void setDataEntrada(LocalDateTime dataEntrada) {
        this.dataEntrada = dataEntrada;
    }
    
    public LocalDateTime getDataSaida() {
        return dataSaida;
    }
    
    public void setDataSaida(LocalDateTime dataSaida) {
        this.dataSaida = dataSaida;
    }
    
    public BigDecimal getValorPago() {
        return valorPago;
    }
    
    public void setValorPago(BigDecimal valorPago) {
        this.valorPago = valorPago;
    }
    
    public String getFormaPagamento() {
        return formaPagamento;
    }
    
    public void setFormaPagamento(String formaPagamento) {
        this.formaPagamento = formaPagamento;
    }
    
    public String getObservacoes() {
        return observacoes;
    }
    
    public void setObservacoes(String observacoes) {
        this.observacoes = observacoes;
    }
}
