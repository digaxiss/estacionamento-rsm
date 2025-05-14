-- Criação do banco de dados para o Sistema de Estacionamento 24 Horas
CREATE DATABASE IF NOT EXISTS estacionamento_db;
USE estacionamento_db;

-- Tabela de usuários (funcionários do estacionamento)
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL, -- Armazenar hash da senha, não a senha em texto puro
    salt VARCHAR(50) NULL, -- Para segurança adicional da senha
    nivel_acesso ENUM('administrador', 'operador') NOT NULL,
    status ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo',
    ultimo_acesso TIMESTAMP NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de veículos estacionados
CREATE TABLE IF NOT EXISTS veiculos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(10) NOT NULL,
    tipo_veiculo VARCHAR(20) NOT NULL DEFAULT 'carro', -- Conforme requisito, só aceita carros
    modelo VARCHAR(50) NULL,
    cor VARCHAR(20) NULL,
    entrada TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    saida TIMESTAMP NULL,
    tempo_permanencia INT NULL, -- Em minutos, calculado na saída
    valor_pago DECIMAL(10,2) NULL,
    forma_pagamento ENUM('dinheiro', 'cartao_debito') NULL, -- Somente as formas aceitas
    usuario_entrada_id INT NOT NULL,
    usuario_saida_id INT NULL,
    observacoes TEXT NULL,
    FOREIGN KEY (usuario_entrada_id) REFERENCES usuarios(id),
    FOREIGN KEY (usuario_saida_id) REFERENCES usuarios(id)
);

-- Tabela para controlar as vagas disponíveis
CREATE TABLE IF NOT EXISTS vagas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL UNIQUE,
    status ENUM('disponivel', 'ocupada', 'manutencao') NOT NULL DEFAULT 'disponivel',
    veiculo_id INT NULL,
    data_atualizacao TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (veiculo_id) REFERENCES veiculos(id)
);

-- Tabela de configurações do sistema
CREATE TABLE IF NOT EXISTS configuracoes (
    chave VARCHAR(50) PRIMARY KEY,
    valor DECIMAL(10,2) NOT NULL,
    descricao VARCHAR(255) NULL,
    data_atualizacao TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela para registro de atividades/log (auditoria)
CREATE TABLE IF NOT EXISTS log_atividades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NULL,
    acao VARCHAR(100) NOT NULL,
    descricao TEXT NULL,
    ip VARCHAR(45) NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Tabela para relatórios de movimentação
CREATE TABLE IF NOT EXISTS relatorios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    parametros TEXT NULL, -- Armazenar parâmetros de filtro em JSON
    resultado TEXT NULL, -- Resultados do relatório em JSON (opcional)
    usuario_id INT NOT NULL,
    data_geracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Inserção de dados iniciais

-- Usuários padrão (senha é 'admin123' e 'operador123' - em produção usar hash)
INSERT INTO usuarios (nome, email, senha, nivel_acesso) VALUES 
('Administrador', 'admin@estacionamento.com', 'admin123', 'administrador'),
('Operador', 'operador@estacionamento.com', 'operador123', 'operador');

-- Configurações iniciais do estacionamento
INSERT INTO configuracoes (chave, valor, descricao) VALUES 
('valor_primeira_hora', 25.00, 'Valor da primeira hora de estacionamento em R$'),
('valor_hora_adicional', 9.00, 'Valor de cada hora adicional em R$'),
('total_vagas', 30, 'Número total de vagas disponíveis no estacionamento');

-- Geração das 30 vagas iniciais
DELIMITER //
CREATE PROCEDURE gerar_vagas()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 30 DO
        INSERT INTO vagas (numero, status) VALUES (i, 'disponivel');
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

CALL gerar_vagas();
DROP PROCEDURE IF EXISTS gerar_vagas;

-- Procedimento para validação de placas (Mercosul e padrão antigo)
DELIMITER //
CREATE PROCEDURE sp_validar_placa(IN p_placa VARCHAR(10), OUT p_valida BOOLEAN)
BEGIN
    -- Validar placa no padrão Mercosul (LLL0L00)
    IF p_placa REGEXP '^[A-Z]{3}[0-9][A-Z][0-9]{2}$' THEN
        SET p_valida = TRUE;
    -- Validar placa no padrão antigo (LLL0000)
    ELSEIF p_placa REGEXP '^[A-Z]{3}[0-9]{4}$' THEN
        SET p_valida = TRUE;
    ELSE
        SET p_valida = FALSE;
    END IF;
END //
DELIMITER ;

-- Procedimento para entrada de veículo
DELIMITER //
CREATE PROCEDURE sp_registrar_entrada(
    IN p_placa VARCHAR(10),
    IN p_tipo_veiculo VARCHAR(20),
    IN p_modelo VARCHAR(50),
    IN p_cor VARCHAR(20),
    IN p_usuario_id INT,
    IN p_observacoes TEXT,
    OUT p_resultado INT
)
BEGIN
    DECLARE v_placa_valida BOOLEAN;
    DECLARE v_vagas_disponiveis INT;
    DECLARE v_vaga_id INT;
    DECLARE v_veiculo_id INT;
    
    -- Validar tipo de veículo (apenas carros)
    IF p_tipo_veiculo != 'carro' THEN
        SET p_resultado = -1; -- Código para tipo de veículo não permitido
        SELECT 'Tipo de veículo não permitido. Apenas carros são aceitos.' AS mensagem;
        LEAVE this_proc;
    END IF;
    
    -- Validar formato da placa
    CALL sp_validar_placa(p_placa, v_placa_valida);
    IF NOT v_placa_valida THEN
        SET p_resultado = -2; -- Código para placa inválida
        SELECT 'Formato de placa inválido.' AS mensagem;
        LEAVE this_proc;
    END IF;
    
    -- Verificar se há vagas disponíveis
    SELECT COUNT(*) INTO v_vagas_disponiveis FROM vagas WHERE status = 'disponivel';
    IF v_vagas_disponiveis = 0 THEN
        SET p_resultado = -3; -- Código para estacionamento lotado
        SELECT 'Não há vagas disponíveis no momento.' AS mensagem;
        LEAVE this_proc;
    END IF;
    
    -- Verificar se veículo já está no estacionamento
    SELECT COUNT(*) INTO @veiculo_existente FROM veiculos 
    WHERE placa = p_placa AND saida IS NULL;
    
    IF @veiculo_existente > 0 THEN
        SET p_resultado = -4; -- Código para veículo já estacionado
        SELECT 'Este veículo já está no estacionamento.' AS mensagem;
        LEAVE this_proc;
    END IF;
    
    -- Iniciar transação
    START TRANSACTION;
    
    -- Registrar entrada do veículo
    INSERT INTO veiculos (placa, tipo_veiculo, modelo, cor, usuario_entrada_id, observacoes)
    VALUES (p_placa, p_tipo_veiculo, p_modelo, p_cor, p_usuario_id, p_observacoes);
    
    SET v_veiculo_id = LAST_INSERT_ID();
    
    -- Alocar uma vaga para o veículo
    SELECT id INTO v_vaga_id FROM vagas WHERE status = 'disponivel' LIMIT 1;
    UPDATE vagas SET status = 'ocupada', veiculo_id = v_veiculo_id WHERE id = v_vaga_id;
    
    -- Registrar log de atividade
    INSERT INTO log_atividades (usuario_id, acao, descricao)
    VALUES (p_usuario_id, 'ENTRADA_VEICULO', CONCAT('Entrada do veículo de placa ', p_placa));
    
    COMMIT;
    
    SET p_resultado = v_vaga_id; -- Retorna o ID da vaga ocupada (sucesso)
    SELECT CONCAT('Veículo de placa ', p_placa, ' registrado com sucesso na vaga ', 
                 (SELECT numero FROM vagas WHERE id = v_vaga_id), '.') AS mensagem;
    
    EXCEPTION:
    -- Em caso de erro, fazer rollback
    ROLLBACK;
    SET p_resultado = -99; -- Código para erro geral
    SELECT 'Erro ao registrar entrada do veículo.' AS mensagem;
END //
DELIMITER ;

-- Índices para melhorar a performance
CREATE INDEX idx_veiculos_placa ON veiculos(placa);
CREATE INDEX idx_veiculos_entrada ON veiculos(entrada);
CREATE INDEX idx_veiculos_saida ON veiculos(saida);
CREATE INDEX idx_vagas_status ON vagas(status);
CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_log_data ON log_atividades(data_hora);

-- Visualização para obter o estado atual do estacionamento
CREATE VIEW vw_status_estacionamento AS
SELECT 
    (SELECT valor FROM configuracoes WHERE chave = 'total_vagas') AS total_vagas,
    (SELECT COUNT(*) FROM vagas WHERE status = 'disponivel') AS vagas_disponiveis,
    (SELECT COUNT(*) FROM vagas WHERE status = 'ocupada') AS vagas_ocupadas,
    (SELECT COUNT(*) FROM veiculos WHERE DATE(entrada) = CURDATE() AND saida IS NOT NULL) AS total_saidas_hoje,
    (SELECT COALESCE(SUM(valor_pago), 0) FROM veiculos WHERE DATE(saida) = CURDATE()) AS faturamento_hoje;

-- Visualização para veículos atualmente estacionados
CREATE VIEW vw_veiculos_estacionados AS
SELECT 
    v.id,
    v.placa,
    v.tipo_veiculo,
    v.modelo,
    v.cor,
    v.entrada,
    va.numero AS vaga,
    TIMESTAMPDIFF(MINUTE, v.entrada, NOW()) AS minutos_permanencia,
    u.nome AS registrado_por
FROM 
    veiculos v
JOIN 
    vagas va ON v.id = va.veiculo_id
JOIN 
    usuarios u ON v.usuario_entrada_id = u.id
WHERE 
    v.saida IS NULL
ORDER BY 
    v.entrada;
