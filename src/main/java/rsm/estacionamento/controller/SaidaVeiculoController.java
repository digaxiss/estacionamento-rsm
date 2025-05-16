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
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.math.BigDecimal;
import java.math.RoundingMode;

import rsm.estacionamento.model.Veiculo;
import rsm.estacionamento.util.ConexaoDB;
import rsm.estacionamento.util.ValidacaoUtil;

/**
 * Servlet responsável pelo controle de saída de veículos do estacionamento
 * Registra a saída e calcula o valor a ser pago
 */
@WebServlet("/saida")
public class SaidaVeiculoController extends HttpServlet {
    
    /**
     * Exibe a página de saída de veículos
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Parâmetro para busca por placa
        String placa = request.getParameter("placa");
        
        if (placa != null && !placa.trim().isEmpty()) {
            try {
                // Busca informações do veículo estacionado
                Veiculo veiculo = buscarVeiculo(placa);
                
                if (veiculo != null) {
                    request.setAttribute("veiculo", veiculo);
                    
                    // Calcula o valor a ser pago
                    BigDecimal valorAPagar = calcularValorAPagar(veiculo.getDataEntrada());
                    request.setAttribute("valorAPagar", valorAPagar);
                    
                    // Calcula o tempo de permanência
                    Duration duracao = Duration.between(veiculo.getDataEntrada(), LocalDateTime.now());
                    long horas = duracao.toHours();
                    long minutos = duracao.toMinutesPart();
                    
                    request.setAttribute("horasPermanencia", horas);
                    request.setAttribute("minutosPermanencia", minutos);
                } else {
                    request.setAttribute("mensagemErro", "Veículo não encontrado ou já saiu do estacionamento.");
                }
            } catch (SQLException e) {
                // Log do erro
                System.err.println("Erro ao buscar veículo: " + e.getMessage());
                
                // Exibe mensagem de erro
                request.setAttribute("mensagemErro", "Erro ao buscar informações do veículo.");
            }
        }
        
        // Encaminha para a página de saída de veículos
        request.getRequestDispatcher("/WEB-INF/view/saida.jsp").forward(request, response);
    }
    
    /**
     * Processa o registro de saída de um veículo
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Obtém os parâmetros do formulário
        String placa = request.getParameter("placa");
        String formaPagamento = request.getParameter("formaPagamento");
        
        if (placa == null || placa.trim().isEmpty() || formaPagamento == null || formaPagamento.trim().isEmpty()) {
            request.setAttribute("mensagemErro", "Placa e forma de pagamento são obrigatórios.");
            doGet(request, response);
            return;
        }
        
        try {
            // Busca informações do veículo estacionado
            Veiculo veiculo = buscarVeiculo(placa);
            
            if (veiculo == null) {
                request.setAttribute("mensagemErro", "Veículo não encontrado ou já saiu do estacionamento.");
                doGet(request, response);
                return;
            }
            
            // Calcula o valor a ser pago
            BigDecimal valorAPagar = calcularValorAPagar(veiculo.getDataEntrada());
            
            // Registra a saída do veículo
            boolean sucesso = registrarSaida(veiculo.getId(), valorAPagar, formaPagamento);
            
            if (sucesso) {
                request.setAttribute("mensagemSucesso", "Saída do veículo registrada com sucesso!");
                request.setAttribute("valorPago", valorAPagar);
            } else {
                request.setAttribute("mensagemErro", "Erro ao registrar saída do veículo.");
            }
            
            doGet(request, response);
            
        } catch (SQLException e) {
            // Log do erro
            System.err.println("Erro ao processar saída de veículo: " + e.getMessage());
            
            // Exibe mensagem de erro
            request.setAttribute("mensagemErro", "Erro ao registrar saída do veículo.");
            doGet(request, response);
        }
    }
    
    /**
     * Busca as informações de um veículo estacionado pela placa
     * @param placa Placa do veículo
     * @return Objeto Veiculo se encontrado, null caso contrário
     * @throws SQLException Em caso de erro no banco de dados
     */
    private Veiculo buscarVeiculo(String placa) throws SQLException {
        String sql = "SELECT id, placa, tipo_veiculo, entrada, observacoes FROM veiculos_estacionados " + "WHERE placa = ? AND saida IS NULL";
        
        try (Connection conn = ConexaoDB.obterConexao();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, placa);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Veiculo veiculo = new Veiculo();
                    veiculo.setId(rs.getInt("id"));
                    veiculo.setPlaca(rs.getString("placa"));
                    veiculo.setTipoVeiculo(rs.getString("tipo_veiculo"));
                    
                    // Converte timestamp do banco para LocalDateTime
                    veiculo.setDataEntrada(rs.getTimestamp("entrada").toLocalDateTime());
                    veiculo.setObservacoes(rs.getString("observacoes"));
                    
                    return veiculo;
                }
            }
        }
        
        return null;
    }
    
    /**
     * Calcula o valor a ser pago com base no tempo de permanência
     * @param dataEntrada Data e hora de entrada do veículo
     * @return Valor a ser pago
     */
    private BigDecimal calcularValorAPagar(LocalDateTime dataEntrada) {
        LocalDateTime dataSaida = LocalDateTime.now();
        Duration duracao = Duration.between(dataEntrada, dataSaida);
        
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
     * Registra a saída de um veículo no banco de dados
     * @param idVeiculo ID do veículo
     * @param valor Valor pago
     * @param formaPagamento Forma de pagamento (dinheiro ou cartão de débito)
     * @return true se o registro foi bem-sucedido, false caso contrário
     * @throws SQLException Em caso de erro no banco de dados
     */
    private boolean registrarSaida(int idVeiculo, BigDecimal valor, String formaPagamento) throws SQLException {
        String sql = "UPDATE veiculos_estacionados SET saida = NOW(), valor_pago = ?, forma_pagamento = ? WHERE id = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBigDecimal(1, valor);
            stmt.setString(2, formaPagamento);
            stmt.setInt(3, idVeiculo);
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
        }
    }
}
