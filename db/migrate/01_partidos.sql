-- ==============================================================================
-- MIGRATE • TABELA: partidos
-- Criação da estrutura de dados das legendas partidárias Pokémon
-- ==============================================================================

CREATE TABLE IF NOT EXISTS `partidos` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `sigla` VARCHAR(20) NOT NULL UNIQUE COMMENT 'Sigla do partido (ex: POKPELE, POKPFGO)',
    `nome` VARCHAR(150) NOT NULL COMMENT 'Nome completo do partido',
    `slogan` VARCHAR(255) NULL COMMENT 'Slogan oficial da legenda',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
