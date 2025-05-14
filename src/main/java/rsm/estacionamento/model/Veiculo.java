package rsm.estacionamento.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Classe que representa um veículo estacionado
 */
public class Veiculo {
    private int id;
    private String placa;
    private String tipoVeiculo;
    private LocalDateTime dataEntrada;
    private LocalDateTime dataSaida;
    private String observacoes;
    
    // Campos adicionais para o dashboard
    private String tempoPermanencia;
    private String valorAtual;
    
    /**
     * Construtor padrão
     */
    public Veiculo() {
    }
    
    /**
     * Construtor com os principais atributos
     */
    public Veiculo(int id, String placa, String tipoVeiculo, LocalDateTime dataEntrada) {
        this.id = id;
        this.placa = placa;
        this.tipoVeiculo = tipoVeiculo;
        this.dataEntrada = dataEntrada;
    }
    
    /**
     * Formata a data de entrada para exibição
     * @return Data formatada como string
     */
    public String getDataEntradaFormatada() {
        if (dataEntrada == null) return "";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        return dataEntrada.format(formatter);
    }
    
    /**
     * Obtém apenas a hora e minuto de entrada formatados
     * @return Hora formatada como string
     */
    public String getHoraEntradaFormatada() {
        if (dataEntrada == null) return "";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
        return dataEntrada.format(formatter);
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
    
    public String getObservacoes() {
        return observacoes;
    }
    
    public void setObservacoes(String observacoes) {
        this.observacoes = observacoes;
    }
    
    // Getters e setters para os campos adicionais
    
    public String getTempoPermanencia() {
        return tempoPermanencia;
    }
    
    public void setTempoPermanencia(String tempoPermanencia) {
        this.tempoPermanencia = tempoPermanencia;
    }
    
    public String getValorAtual() {
        return valorAtual;
    }
    
    public void setValorAtual(String valorAtual) {
        this.valorAtual = valorAtual;
    }
}
