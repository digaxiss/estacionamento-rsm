-- Ajuste na tabela de veículos para incluir categoria e validação de placas
ALTER TABLE veiculos_estacionados
ADD COLUMN categoria VARCHAR(20) NOT NULL DEFAULT 'carro' CHECK (categoria = 'carro'),
MODIFY COLUMN forma_pagamento ENUM('dinheiro', 'cartao_debito') NULL COMMENT 'Apenas dinheiro ou cartão de débito conforme requisito';

-- Tabela para relatórios de movimentação
CREATE TABLE IF NOT EXISTS relatorios_movimentacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    total_veiculos INT NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    data_geracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_id INT NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Adicionar procedimento para validação de placas (Mercosul e padrão antigo)
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

-- Adicionando trigger para validar categoria de veículo (rejeitar motos e caminhões)
DELIMITER //
CREATE TRIGGER tr_validar_categoria_veiculo
BEFORE INSERT ON veiculos_estacionados
FOR EACH ROW
BEGIN
    IF NEW.categoria != 'carro' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Categoria inválida. Apenas carros são aceitos neste estacionamento.';
    END IF;
END //
DELIMITER ;
