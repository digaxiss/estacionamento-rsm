-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS estacionamento_db;
USE estacionamento_db;

-- Tabela de usuários (funcionários)
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(100) NOT NULL,
    nivel_acesso ENUM('administrador', 'operador') NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultimo_acesso TIMESTAMP NULL
);

-- Tabela de veículos estacionados
CREATE TABLE IF NOT EXISTS veiculos_estacionados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(10) NOT NULL,
    tipo_veiculo VARCHAR(50) NOT NULL,
    entrada TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    saida TIMESTAMP NULL,
    valor_pago DECIMAL(10,2) NULL,
    forma_pagamento ENUM('dinheiro', 'cartao_debito', 'pix') NULL,
    observacoes TEXT NULL
);

-- Tabela de configurações do sistema
CREATE TABLE IF NOT EXISTS configuracoes (
    chave VARCHAR(50) PRIMARY KEY,
    valor DECIMAL(10,2) NOT NULL,
    descricao VARCHAR(255) NULL
);

-- Inserção de dados iniciais

-- Usuário administrador padrão
INSERT INTO usuarios (nome, email, senha, nivel_acesso) 
VALUES ('Administrador', 'admin@estacionamento.com', 'admin123', 'administrador');

-- Usuário operador padrão
INSERT INTO usuarios (nome, email, senha, nivel_acesso) 
VALUES ('Operador', 'operador@estacionamento.com', 'operador123', 'operador');

-- Configurações padrão
INSERT INTO configuracoes (chave, valor, descricao) 
VALUES 
('valor_primeira_hora', 25.00, 'Valor da primeira hora de estacionamento'),
('valor_hora_adicional', 9.00, 'Valor da hora adicional de estacionamento'),
('total_vagas', 30, 'Número total de vagas disponíveis no estacionamento');

-- Criação de índices para melhorar a performance
CREATE INDEX idx_veiculos_placa ON veiculos_estacionados(placa);
CREATE INDEX idx_veiculos_entrada ON veiculos_estacionados(entrada);
CREATE INDEX idx_veiculos_saida ON veiculos_estacionados(saida);
