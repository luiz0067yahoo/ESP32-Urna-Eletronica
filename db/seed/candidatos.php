<?php
/**
 * Povoamento PHP Individual: Tabela 'candidatos'
 */
require_once __DIR__ . '/../../backend/conecta.php';

$sqlSeedCandidatos = <<<SQL
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
SQL;

if (basename(__FILE__) === basename($_SERVER['SCRIPT_FILENAME'] ?? $_SERVER['PHP_SELF'] ?? '')) {
    header('Content-Type: text/plain; charset=utf-8');
    echo "▶ Executando seed da tabela 'candidatos'...\n";
    try {
        $db = Conexao::getConexao();
        if ($db) {
            $db->exec($sqlSeedCandidatos);
            echo "✔ Candidatos semeados com sucesso!\n";
        }
    } catch (Exception $e) {
        echo "❌ Erro ao semear candidatos: " . $e->getMessage() . "\n";
    }
}

return $sqlSeedCandidatos;
