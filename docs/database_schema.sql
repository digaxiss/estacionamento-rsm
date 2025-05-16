-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS estacionamento_db;
USE estacionamento_db;

-- Tabela de usuários
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    nivel_acesso ENUM('administrador', 'operador') NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de veículos estacionados
CREATE TABLE IF NOT EXISTS veiculos_estacionados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(8) NOT NULL,
    tipo_veiculo VARCHAR(50) NOT NULL,
    entrada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    saida TIMESTAMP NULL,
    valor_pago DECIMAL(10,2) NULL,
    forma_pagamento VARCHAR(50) NULL,
    observacoes TEXT NULL,
    id_usuario_entrada INT NULL,
    id_usuario_saida INT NULL,
    FOREIGN KEY (id_usuario_entrada) REFERENCES usuarios(id),
    FOREIGN KEY (id_usuario_saida) REFERENCES usuarios(id)
);

-- Tabela de configurações
CREATE TABLE IF NOT EXISTS configuracoes (
    chave VARCHAR(50) PRIMARY KEY,
    valor VARCHAR(255) NOT NULL,
    descricao TEXT NULL
);

-- Inserir configurações iniciais
INSERT INTO configuracoes (chave, valor, descricao) VALUES 
('valor_primeira_hora', '25.00', 'Valor da primeira hora de estacionamento'),
('valor_hora_adicional', '9.00', 'Valor de cada hora adicional de estacionamento'),
('total_vagas', '30', 'Número total de vagas disponíveis no estacionamento');

-- Inserir usuário administrador padrão (senha: admin123)
INSERT INTO usuarios (nome, email, senha, nivel_acesso) VALUES 
('Administrador', 'admin@sistema.com', 'admin123', 'administrador');

-- Inserir usuário operador para testes (senha: operador123)
INSERT INTO usuarios (nome, email, senha, nivel_acesso) VALUES 
('Operador', 'operador@sistema.com', 'operador123', 'operador');
