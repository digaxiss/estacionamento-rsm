package com.estacionamento.service;

import com.estacionamento.model.Movimentacao;
import com.estacionamento.util.DatabaseConfig;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

public class MovimentacaoService {

    // Registrar entrada de veículo com transação
    public int registrarEntrada(String placa, String modelo, String cor) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            // Obter conexão do pool
            conn = DatabaseConfig.getConnection();
            
            // Desativar auto-commit para iniciar a transação
            conn.setAutoCommit(false);
            
            // Verificar se há vagas disponíveis
            String sqlVagas = "SELECT COUNT(*) FROM movimentacoes WHERE saida IS NULL";
            try (PreparedStatement stmtVagas = conn.prepareStatement(sqlVagas);
                 ResultSet rs = stmtVagas.executeQuery()) {
                
                rs.next();
                int ocupadas = rs.getInt(1);
                
                // Consultar número total de vagas (da tabela de configurações)
                String sqlTotal = "SELECT valor FROM configuracoes WHERE chave = 'total_vagas'";
                try (PreparedStatement stmtTotal = conn.prepareStatement(sqlTotal);
                     ResultSet rsTotal = stmtTotal.executeQuery()) {
                    
                    rsTotal.next();
                    int totalVagas = Integer.parseInt(rsTotal.getString("valor"));
                    
                    if (ocupadas >= totalVagas) {
                        throw new RuntimeException("Não há vagas disponíveis no momento.");
                    }
                }
            }
            
            // Inserir a movimentação
            String sql = "INSERT INTO movimentacoes (placa, modelo, cor, entrada) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            stmt.setString(1, placa.toUpperCase());
            stmt.setString(2, modelo);
            stmt.setString(3, cor);
            stmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Falha ao criar registro de entrada, nenhuma linha afetada.");
            }
            
            // Obter o ID gerado
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int id = generatedKeys.getInt(1);
                    
                    // Commit da transação
                    conn.commit();
                    
                    return id;
                } else {
                    throw new SQLException("Falha ao criar registro de entrada, nenhum ID obtido.");
                }
            }
            
        } catch (Exception e) {
            // Rollback em caso de erro
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            
            throw new RuntimeException("Erro ao registrar entrada de veículo", e);
        } finally {
            // Fechar recursos e restaurar auto-commit
            try {
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
