-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Tempo de geração: 16/05/2025 às 15:53
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `estacionamento_db`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `configuracoes`
--

CREATE TABLE `configuracoes` (
  `chave` varchar(50) NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `descricao` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `configuracoes`
--

INSERT INTO `configuracoes` (`chave`, `valor`, `descricao`) VALUES
('total_vagas', 30.00, 'Número total de vagas disponíveis no estacionamento'),
('valor_hora_adicional', 9.00, 'Valor da hora adicional de estacionamento'),
('valor_primeira_hora', 25.00, 'Valor da primeira hora de estacionamento');

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(100) NOT NULL,
  `nivel_acesso` enum('administrador','operador') NOT NULL,
  `data_criacao` timestamp NOT NULL DEFAULT current_timestamp(),
  `ultimo_acesso` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `usuarios`
--

INSERT INTO `usuarios` (`id`, `nome`, `email`, `senha`, `nivel_acesso`, `data_criacao`, `ultimo_acesso`) VALUES
(1, 'Maria clara', 'mari@pupup.com', 'idontknow', 'administrador', '2025-05-06 03:32:01', NULL),
(3, 'Rafael Souto', 'rafael@souto.com', 'eunaosei', 'administrador', '2001-09-26 06:00:00', NULL),
(4, 'Prof° Gal', 'gal@senai.com', 'password', 'administrador', '2025-05-16 01:54:40', NULL),
(10, 'O JAVA CORROMPE O HOMEM AHHHHHHHHHHHh', 'eu@cansei.com', '1234', 'administrador', '2025-05-16 13:42:59', NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `veiculos_estacionados`
--

CREATE TABLE `veiculos_estacionados` (
  `id` int(11) NOT NULL,
  `placa` varchar(10) NOT NULL,
  `tipo_veiculo` varchar(50) NOT NULL,
  `entrada` timestamp NOT NULL DEFAULT current_timestamp(),
  `saida` timestamp NULL DEFAULT NULL,
  `valor_pago` decimal(10,2) DEFAULT NULL,
  `forma_pagamento` enum('dinheiro','cartao_debito','pix') DEFAULT NULL,
  `observacoes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `veiculos_estacionados`
--

INSERT INTO `veiculos_estacionados` (`id`, `placa`, `tipo_veiculo`, `entrada`, `saida`, `valor_pago`, `forma_pagamento`, `observacoes`) VALUES
(1, 'ADB1234', 'carro', '2025-05-06 09:03:05', '2025-05-06 09:10:00', 25.00, 'dinheiro', ''),
(2, 'JKL1M23', 'suv', '2025-05-06 16:45:25', '2025-05-14 14:22:59', 1726.00, 'dinheiro', 'VIDRO QUEBRADO!'),
(3, 'EZX2948', 'carro', '2025-05-06 16:46:17', NULL, NULL, NULL, ''),
(4, 'AZO1834', 'suv', '2025-05-06 19:56:17', '2025-05-12 18:51:51', 1303.00, 'dinheiro', 'ROUBADO'),
(5, 'QWS3434', 'carro', '2025-05-06 19:57:56', '2025-05-06 19:58:14', 25.00, 'pix', 'Branco'),
(6, 'abc1234', 'suv', '2025-05-12 17:22:16', NULL, NULL, NULL, 'lllllll'),
(7, 'ADB1234', 'suv', '2025-05-13 18:06:48', '2025-05-13 18:07:03', 25.00, 'dinheiro', ''),
(8, 'BXV9327', 'suv', '2025-05-13 19:03:09', '2025-05-14 14:25:51', 196.00, 'dinheiro', ''),
(9, 'KDJ4K89', 'carro', '2025-05-13 19:03:43', NULL, NULL, NULL, 'RISCO NO PARA-CHOQUE\r\n'),
(10, 'BHN6777', 'pickup', '2025-05-13 19:04:31', NULL, NULL, NULL, ''),
(11, 'CXC2346', 'carro', '2025-05-14 09:04:32', '2025-05-14 14:38:42', 70.00, 'dinheiro', ''),
(12, 'NCJ9888', 'pickup', '2025-05-14 14:18:54', NULL, NULL, NULL, ''),
(13, 'LLL2394', 'carro', '2025-05-14 14:22:49', NULL, NULL, NULL, ''),
(14, 'AZO1834', 'carro', '2025-05-14 14:25:28', NULL, NULL, NULL, ''),
(15, 'KKK2341', 'carro', '2025-05-14 14:32:21', NULL, NULL, NULL, ''),
(16, 'GGG7460', 'suv', '2025-05-14 17:02:23', '2025-05-14 17:03:12', 25.00, 'cartao_debito', ''),
(17, 'kkd2343', 'carro', '2025-05-14 17:08:35', NULL, NULL, NULL, ''),
(18, 'GAL5513', 'pickup', '2025-05-14 17:27:55', '2025-05-14 17:29:13', 25.00, 'cartao_debito', 'CARRO DO GALZERA'),
(19, 'KKJ2375', 'suv', '2025-05-15 11:14:45', '2025-05-15 11:15:06', 25.00, 'cartao_debito', ''),
(20, 'QWS3434', 'pickup', '2025-05-15 14:15:35', '2025-05-15 14:15:48', 25.00, 'cartao_debito', ''),
(21, 'KJG9899', 'carro', '2025-05-16 02:18:38', '2025-05-16 02:18:46', 25.00, 'dinheiro', '');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `configuracoes`
--
ALTER TABLE `configuracoes`
  ADD PRIMARY KEY (`chave`);

--
-- Índices de tabela `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Índices de tabela `veiculos_estacionados`
--
ALTER TABLE `veiculos_estacionados`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_veiculos_placa` (`placa`),
  ADD KEY `idx_veiculos_entrada` (`entrada`),
  ADD KEY `idx_veiculos_saida` (`saida`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `veiculos_estacionados`
--
ALTER TABLE `veiculos_estacionados`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
