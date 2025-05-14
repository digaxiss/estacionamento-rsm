USE estacionamento_db;

-- Melhoria na segurança das senhas
ALTER TABLE usuarios 
ADD COLUMN salt VARCHAR(100) NULL AFTER senha,
ADD COLUMN token_reset VARCHAR(100) NULL,
ADD COLUMN token_expiracao TIMESTAMP NULL;

-- Tabela para clientes mensalistas
CREATE TABLE IF NOT EXISTS clientes_mensalistas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(20),
    documento VARCHAR(20) NOT NULL,
    placa_veiculo VARCHAR(10) NOT NULL,
    modelo_veiculo VARCHAR(50),
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    valor_mensal DECIMAL(10,2) NOT NULL,
    status ENUM('ativo', 'inativo', 'vencido') NOT NULL DEFAULT 'ativo',
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela para registrar pagamentos
CREATE TABLE IF NOT EXISTS pagamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    veiculo_id INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    forma_pagamento ENUM('dinheiro', 'cartao_debito', 'cartao_credito', 'pix') NOT NULL,
    data_pagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_id INT NOT NULL,
    observacoes TEXT NULL,
    FOREIGN KEY (veiculo_id) REFERENCES veiculos_estacionados(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Tabela para log de operações (auditoria)
CREATE TABLE IF NOT EXISTS log_operacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    acao VARCHAR(100) NOT NULL,
    tabela_afetada VARCHAR(50),
    registro_id INT,
    detalhes TEXT,
    ip_origem VARCHAR(45),
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Índices adicionais
CREATE INDEX idx_mensalistas_placa ON clientes_mensalistas(placa_veiculo);
CREATE INDEX idx_mensalistas_status ON clientes_mensalistas(status);
CREATE INDEX idx_pagamentos_data ON pagamentos(data_pagamento);
CREATE INDEX idx_log_data ON log_operacoes(data_hora);
