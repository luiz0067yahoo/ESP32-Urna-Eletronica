-- ==============================================================================
-- URNA ELETRÔNICA POKÉMON • DUMP SQL COMPLETO PARA HOSPEDAGEM TRADICIONAL
-- Compatibilidade: MySQL 5.7+, MySQL 8.x, MariaDB 10.x+ (phpMyAdmin, cPanel, etc.)
-- Codificação: UTF-8 Unicode (utf8mb4)
-- ==============================================================================

SET NAMES utf8mb4;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

-- ------------------------------------------------------------------------------
-- 1. ESTRUTURA DA TABELA: votos
-- Armazena todos os votos computados individualmente na Urna Eletrônica
-- ------------------------------------------------------------------------------
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

-- ------------------------------------------------------------------------------
-- 2. ESTRUTURA DA TABELA: partidos
-- Armazena as legendas partidárias do universo Pokémon
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `partidos` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `sigla` VARCHAR(20) NOT NULL UNIQUE COMMENT 'Sigla do partido (ex: POKPELE, POKPFGO)',
    `nome` VARCHAR(150) NOT NULL COMMENT 'Nome completo do partido',
    `slogan` VARCHAR(255) NULL COMMENT 'Slogan oficial da legenda',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 3. ESTRUTURA DA TABELA: candidatos
-- Armazena os candidatos de todos os 6 cargos eleitorais oficiais
-- ------------------------------------------------------------------------------
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

-- ------------------------------------------------------------------------------
-- 4. POVOAMENTO INICIAL (SEED): partidos
-- ------------------------------------------------------------------------------
INSERT INTO `partidos` (`sigla`, `nome`, `slogan`) VALUES
('POKPELE', 'Partido Organizado Karvalho Professor Elétrico', 'Energia e inovação para todos.'),
('POKPFGO', 'Partido Organizado Karvalho Professor Fogo', 'Chama da mudança e energia que move o país.'),
('POKPAGU', 'Partido Organizado Karvalho Professor Água', 'Água é vida e preservação.'),
('POKPPLA', 'Partido Organizado Karvalho Professor Planta', 'Mais verde, mais futuro sustentável.'),
('POKPNOR', 'Partido Organizado Karvalho Professor Normal', 'Equilíbrio, transparência e bom senso.'),
('POKPLUT', 'Partido Organizado Karvalho Professor Lutador', 'Determinação, esporte e superação.'),
('POKPPED', 'Partido Organizado Karvalho Professor Pedra', 'Base sólida para o desenvolvimento.'),
('POKPVEN', 'Partido Organizado Karvalho Professor Veneno', 'Defesa, proteção e vigilância.'),
('POKPPSI', 'Partido Organizado Karvalho Professor Psíquico', 'Conhecimento, ciência e sabedoria.'),
('POKPACO', 'Partido Organizado Karvalho Professor Aço', 'Estrutura forte e duradoura.'),
('POKPDRA', 'Partido Organizado Karvalho Professor Dragão', 'Força e liderança estratégica.')
ON DUPLICATE KEY UPDATE `nome` = VALUES(`nome`), `slogan` = VALUES(`slogan`);

-- ------------------------------------------------------------------------------
-- 5. POVOAMENTO INICIAL (SEED): candidatos
-- ------------------------------------------------------------------------------
-- Presidente da República
INSERT INTO `candidatos` (`numero`, `nome`, `cargo`, `partido`, `foto`, `vice`, `foto_vice`) VALUES
('65', 'Pikachu', 'PRESIDENTE', 'POKPELE', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png', 'Totodile', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/158.png'),
('63', 'Squirtle', 'PRESIDENTE', 'POKPAGU', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/7.png', 'Bulbasaur', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png'),
('62', 'Charmander', 'PRESIDENTE', 'POKPFGO', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png', 'Flareon', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/136.png')
ON DUPLICATE KEY UPDATE `nome` = VALUES(`nome`), `partido` = VALUES(`partido`), `foto` = VALUES(`foto`);

-- Governador de Estado
INSERT INTO `candidatos` (`numero`, `nome`, `cargo`, `partido`, `foto`, `vice`, `foto_vice`) VALUES
('81', 'Manectric', 'GOVERNADOR', 'POKPELE', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/310.png', 'Ampharos', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/181.png'),
('82', 'Zapdos', 'GOVERNADOR', 'POKPELE', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/145.png', 'Jolteon', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/135.png'),
('83', 'Luxray', 'GOVERNADOR', 'POKPELE', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/405.png', 'Electabuzz', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/125.png'),
('84', 'Magmortar', 'GOVERNADOR', 'POKPFGO', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/467.png', 'Arcanine', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/59.png'),
('85', 'Blaziken', 'GOVERNADOR', 'POKPFGO', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/257.png', 'Ninetales', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/38.png'),
('86', 'Infernape', 'GOVERNADOR', 'POKPFGO', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/392.png', 'Typhlosion', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/157.png'),
('87', 'Feraligatr', 'GOVERNADOR', 'POKPAGU', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/160.png', 'Gyarados', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/130.png'),
('88', 'Greninja', 'GOVERNADOR', 'POKPAGU', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/658.png', 'Vaporeon', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/134.png'),
('89', 'Swampert', 'GOVERNADOR', 'POKPAGU', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/260.png', 'Lapras', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/131.png')
ON DUPLICATE KEY UPDATE `nome` = VALUES(`nome`), `partido` = VALUES(`partido`), `foto` = VALUES(`foto`);

-- 1º e 2º Senador
INSERT INTO `candidatos` (`numero`, `nome`, `cargo`, `partido`, `foto`, `vice`, `foto_vice`) VALUES
('701', 'Alakazam', '1º SENADOR', 'POKPPSI', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/65.png', NULL, NULL),
('702', 'Gengar', '1º SENADOR', 'POKPFAN', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/94.png', NULL, NULL),
('703', 'Dragonite', '1º SENADOR', 'POKPDRA', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/149.png', NULL, NULL),
('751', 'Mewtwo', '2º SENADOR', 'POKPPSI', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/150.png', NULL, NULL),
('752', 'Lugia', '2º SENADOR', 'POKPPSI', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/249.png', NULL, NULL),
('753', 'Ho-Oh', '2º SENADOR', 'POKPFGO', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/250.png', NULL, NULL)
ON DUPLICATE KEY UPDATE `nome` = VALUES(`nome`), `partido` = VALUES(`partido`), `foto` = VALUES(`foto`);

-- Deputado Federal
INSERT INTO `candidatos` (`numero`, `nome`, `cargo`, `partido`, `foto`, `vice`, `foto_vice`) VALUES
('9101', 'Raichu', 'DEPUTADO FEDERAL', 'POKPELE', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/26.png', NULL, NULL),
('9102', 'Jolteon', 'DEPUTADO FEDERAL', 'POKPELE', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/135.png', NULL, NULL),
('9201', 'Charizard', 'DEPUTADO FEDERAL', 'POKPFGO', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png', NULL, NULL),
('9301', 'Blastoise', 'DEPUTADO FEDERAL', 'POKPAGU', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/9.png', NULL, NULL)
ON DUPLICATE KEY UPDATE `nome` = VALUES(`nome`), `partido` = VALUES(`partido`), `foto` = VALUES(`foto`);

-- Deputado Estadual
INSERT INTO `candidatos` (`numero`, `nome`, `cargo`, `partido`, `foto`, `vice`, `foto_vice`) VALUES
('90101', 'Pichu', 'DEPUTADO ESTADUAL', 'POKPELE', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/172.png', NULL, NULL),
('90102', 'Mareep', 'DEPUTADO ESTADUAL', 'POKPELE', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/179.png', NULL, NULL),
('90201', 'Cyndaquil', 'DEPUTADO ESTADUAL', 'POKPFGO', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/155.png', NULL, NULL),
('90301', 'Totodile', 'DEPUTADO ESTADUAL', 'POKPAGU', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/158.png', NULL, NULL)
ON DUPLICATE KEY UPDATE `nome` = VALUES(`nome`), `partido` = VALUES(`partido`), `foto` = VALUES(`foto`);

-- ------------------------------------------------------------------------------
-- 6. VOTOS INICIAIS DE DEMONSTRAÇÃO (Opcional - para ver a apuração povoada)
-- ------------------------------------------------------------------------------
INSERT INTO `votos` (`cargo`, `numero_candidato`) VALUES
('PRESIDENTE', '65'), ('PRESIDENTE', '65'), ('PRESIDENTE', '65'), ('PRESIDENTE', '65'), ('PRESIDENTE', '65'),
('PRESIDENTE', '63'), ('PRESIDENTE', '63'), ('PRESIDENTE', '63'), ('PRESIDENTE', '63'),
('PRESIDENTE', '62'), ('PRESIDENTE', '62'),
('PRESIDENTE', 'BRANCO'),
('GOVERNADOR', '81'), ('GOVERNADOR', '81'), ('GOVERNADOR', '81'), ('GOVERNADOR', '81'),
('GOVERNADOR', '85'), ('GOVERNADOR', '85'), ('GOVERNADOR', '85'),
('GOVERNADOR', '88'), ('GOVERNADOR', '88'),
('1º SENADOR', '701'), ('1º SENADOR', '701'), ('1º SENADOR', '701'),
('1º SENADOR', '702'), ('1º SENADOR', '702'),
('1º SENADOR', '703'),
('2º SENADOR', '751'), ('2º SENADOR', '751'), ('2º SENADOR', '751'), ('2º SENADOR', '751'),
('2º SENADOR', '752'), ('2º SENADOR', '752'),
('DEPUTADO FEDERAL', '9101'), ('DEPUTADO FEDERAL', '9101'), ('DEPUTADO FEDERAL', '9101'),
('DEPUTADO FEDERAL', '9201'), ('DEPUTADO FEDERAL', '9201'),
('DEPUTADO FEDERAL', '9301'),
('DEPUTADO ESTADUAL', '90101'), ('DEPUTADO ESTADUAL', '90101'), ('DEPUTADO ESTADUAL', '90101'), ('DEPUTADO ESTADUAL', '90101'),
('DEPUTADO ESTADUAL', '90201'), ('DEPUTADO ESTADUAL', '90201');

SET foreign_key_checks = 1;
