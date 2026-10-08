-- ==============================================================================
-- MIGRATE • TABELA: votos
-- Criação da estrutura de dados para computação de votos da Urna Eletrônica
-- ==============================================================================

CREATE TABLE IF NOT EXISTS `votos` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `cargo` VARCHAR(100) NOT NULL COMMENT 'Cargo eletivo (ex: PRESIDENTE, GOVERNADOR, etc.)',
    `numero_candidato` VARCHAR(20) NOT NULL COMMENT 'Número digitado ou BRANCO / NULO',
    `data_voto` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Data e hora da computação do voto',
    INDEX `idx_cargo` (`cargo`),
    INDEX `idx_numero_candidato` (`numero_candidato`),
    INDEX `idx_cargo_numero` (`cargo`, `numero_candidato`),
    INDEX `idx_data_voto` (`data_voto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
