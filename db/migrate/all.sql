-- ==============================================================================
-- MIGRATE COMPLETO • TODAS AS TABELAS
-- Executa a criação de todas as tabelas em ordem
-- ==============================================================================

SET NAMES utf8mb4;
SET foreign_key_checks = 0;

-- 1. Partidos
CREATE TABLE IF NOT EXISTS `partidos` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `sigla` VARCHAR(20) NOT NULL UNIQUE COMMENT 'Sigla do partido (ex: POKPELE, POKPFGO)',
    `nome` VARCHAR(150) NOT NULL COMMENT 'Nome completo do partido',
    `slogan` VARCHAR(255) NULL COMMENT 'Slogan oficial da legenda',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Candidatos
CREATE TABLE IF NOT EXISTS `candidatos` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `numero` VARCHAR(20) NOT NULL UNIQUE COMMENT 'Número na urna',
    `nome` VARCHAR(100) NOT NULL COMMENT 'Nome do Pokémon candidato',
    `cargo` VARCHAR(100) NOT NULL COMMENT 'Cargo concorrido',
    `partido` VARCHAR(20) NOT NULL COMMENT 'Sigla do partido coligado',
    `foto` VARCHAR(255) NULL COMMENT 'URL da ilustração oficial PokeAPI',
    `vice` VARCHAR(100) NULL COMMENT 'Nome do vice / suplente',
    `foto_vice` VARCHAR(255) NULL COMMENT 'URL da foto do vice / suplente',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_cand_cargo` (`cargo`),
    INDEX `idx_cand_partido` (`partido`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Votos
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

SET foreign_key_checks = 1;
