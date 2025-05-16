package com.estacionamento.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Classe que representa a movimentação de um veículo no estacionamento
 */
public class Movimentacao implements Serializable {
    
    private Long id;
    private String placa;
    private String tipoVeiculo;
    private Date dataEntrada;
    private Date dataSaida;
    private BigDecimal valorPago;
    private String formaPagamento;
    private String observacoes;
    
    // Construtor vazio
    public Movimentacao() {
    }
    
    // Construtor para registro de entrada
    public Movimentacao(String placa, String tipoVeiculo, String observacoes) {
        this.placa = placa;
        this.tipoVeiculo = tipoVeiculo;
        this.dataEntrada = new Date();
        this.observacoes = observacoes;
    }
    
    // Getters e Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
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
    
    public Date getDataEntrada() {
        return dataEntrada;
    }
    
    public void setDataEntrada(Date dataEntrada) {
        this.dataEntrada = dataEntrada;
    }
    
    public Date getDataSaida() {
        return dataSaida;
    }
    
    public void setDataSaida(Date dataSaida) {
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
    
    // Métodos para formatação de datas e valores
    public String getDataEntradaFormatada() {
        if (dataEntrada == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        return sdf.format(dataEntrada);
    }
    
    public String getHoraEntradaFormatada() {
        if (dataEntrada == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        return sdf.format(dataEntrada);
    }
    
    public String getDataSaidaFormatada() {
        if (dataSaida == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        return sdf.format(dataSaida);
    }
    
    public String getHoraSaidaFormatada() {
        if (dataSaida == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        return sdf.format(dataSaida);
    }
    
    public String getValorPagoFormatado() {
        if (valorPago == null) return "";
        NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));
        return nf.format(valorPago).replace("R$ ", "");
    }
    
    @Override
    public String toString() {
        return "Movimentacao{" + "id=" + id + ", placa=" + placa + ", tipoVeiculo=" + tipoVeiculo + ", dataEntrada=" + dataEntrada + ", dataSaida=" + dataSaida + '}';
    }
}
