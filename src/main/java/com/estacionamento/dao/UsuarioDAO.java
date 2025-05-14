package com.estacionamento.dao;

import com.estacionamento.model.Usuario;
import com.estacionamento.util.DatabaseConfig;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    // Buscar um usuário pelo email
    public Usuario buscarPorEmail(String email) {
        String sql = "SELECT * FROM usuarios WHERE email = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Usuario usuario = new Usuario();
                    usuario.setId(rs.getInt("id"));
                    usuario.setNome(rs.getString("nome"));
                    usuario.setEmail(rs.getString("email"));
                    usuario.setSenha(rs.getString("senha"));
                    usuario.setNivelAcesso(rs.getString("nivel_acesso"));
                    return usuario;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar usuário por email", e);
        }
        
        return null;
    }
    
    // Listar todos os usuários
    public List<Usuario> listarTodos() {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT * FROM usuarios ORDER BY nome";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setId(rs.getInt("id"));
                usuario.setNome(rs.getString("nome"));
                usuario.setEmail(rs.getString("email"));
                usuario.setSenha(rs.getString("senha"));
                usuario.setNivelAcesso(rs.getString("nivel_acesso"));
                usuarios.add(usuario);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar usuários", e);
        }
        
        return usuarios;
    }
    
    // Inserir um novo usuário
    public boolean inserir(Usuario usuario) {
        String sql = "INSERT INTO usuarios (nome, email, senha, nivel_acesso) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, usuario.getNome());
            stmt.setString(2, usuario.getEmail());
            stmt.setString(3, usuario.getSenha());
            stmt.setString(4, usuario.getNivelAcesso());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao inserir usuário", e);
        }
    }
    
    // Atualizar um usuário existente
    public boolean atualizar(Usuario usuario) {
        String sql = "UPDATE usuarios SET nome = ?, email = ?, nivel_acesso = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, usuario.getNome());
            stmt.setString(2, usuario.getEmail());
            stmt.setString(3, usuario.getNivelAcesso());
            stmt.setInt(4, usuario.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao atualizar usuário", e);
        }
    }
    
    // Excluir um usuário
    public boolean excluir(int id) {
        String sql = "DELETE FROM usuarios WHERE id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao excluir usuário", e);
        }
    }
}
