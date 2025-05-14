package com.estacionamento.model;

import java.io.Serializable;

/**
 * Classe que representa um usuário do sistema
 */
public class Usuario implements Serializable {
    
    private Long id;
    private String nome;
    private String email;
    private String senha;
    private String nivelAcesso;
    
    // Construtor vazio
    public Usuario() {
    }
    
    // Construtor com parâmetros
    public Usuario(Long id, String nome, String email, String senha, String nivelAcesso) {
        this.id = id;
        this.nome = nome;
        this.email = email;
        this.senha = senha;
        this.nivelAcesso = nivelAcesso;
    }
    
    // Getters e Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getNome() {
        return nome;
    }
    
    public void setNome(String nome) {
        this.nome = nome;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getSenha() {
        return senha;
    }
    
    public void setSenha(String senha) {
        this.senha = senha;
    }
    
    public String getNivelAcesso() {
        return nivelAcesso;
    }
    
    public void setNivelAcesso(String nivelAcesso) {
        this.nivelAcesso = nivelAcesso;
    }
    
    @Override
    public String toString() {
        return "Usuario{" + "id=" + id + ", nome=" + nome + ", email=" + email + ", nivelAcesso=" + nivelAcesso + '}';
    }
}
