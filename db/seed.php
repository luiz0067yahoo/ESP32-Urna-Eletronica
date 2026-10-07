<?php
/**
 * Seed (Povoamento Inicial) - Urna Eletrônica Pokémon
 * Todo o conteúdo SQL armazenado em uma string PHP
 */

require_once __DIR__ . '/../backend/conecta.php';

$sqlSeed = <<<SQL
-- 1. Partidos Políticos Pokémon
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

-- 2. Candidatos à Presidência da República
INSERT INTO `candidatos` (`numero`, `nome`, `cargo`, `partido`, `foto`, `vice`, `foto_vice`) VALUES
('65', 'Pikachu', 'PRESIDENTE', 'POKPELE', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png', 'Totodile', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/158.png'),
('63', 'Squirtle', 'PRESIDENTE', 'POKPAGU', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/7.png', 'Bulbasaur', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png'),
('62', 'Charmander', 'PRESIDENTE', 'POKPFGO', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png', 'Flareon', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/136.png')
ON DUPLICATE KEY UPDATE `nome` = VALUES(`nome`), `partido` = VALUES(`partido`), `foto` = VALUES(`foto`);

-- 3. Candidatos a Governador
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

-- 4. Candidatos a Senador (1º e 2º Senador)
INSERT INTO `candidatos` (`numero`, `nome`, `cargo`, `partido`, `foto`, `vice`, `foto_vice`) VALUES
('701', 'Alakazam', '1º SENADOR', 'POKPPSI', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/65.png', NULL, NULL),
('702', 'Gengar', '1º SENADOR', 'POKPFAN', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/94.png', NULL, NULL),
('703', 'Dragonite', '1º SENADOR', 'POKPDRA', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/149.png', NULL, NULL),
('751', 'Mewtwo', '2º SENADOR', 'POKPPSI', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/150.png', NULL, NULL),
('752', 'Lugia', '2º SENADOR', 'POKPPSI', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/249.png', NULL, NULL),
('753', 'Ho-Oh', '2º SENADOR', 'POKPFGO', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/250.png', NULL, NULL)
ON DUPLICATE KEY UPDATE `nome` = VALUES(`nome`), `partido` = VALUES(`partido`), `foto` = VALUES(`foto`);

-- 5. Candidatos a Deputado Federal e Estadual
INSERT INTO `candidatos` (`numero`, `nome`, `cargo`, `partido`, `foto`, `vice`, `foto_vice`) VALUES
('9101', 'Raichu', 'DEPUTADO FEDERAL', 'POKPELE', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/26.png', NULL, NULL),
('9102', 'Jolteon', 'DEPUTADO FEDERAL', 'POKPELE', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/135.png', NULL, NULL),
('9201', 'Charizard', 'DEPUTADO FEDERAL', 'POKPFGO', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png', NULL, NULL),
('9301', 'Blastoise', 'DEPUTADO FEDERAL', 'POKPAGU', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/9.png', NULL, NULL),
('90101', 'Pichu', 'DEPUTADO ESTADUAL', 'POKPELE', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/172.png', NULL, NULL),
('90102', 'Mareep', 'DEPUTADO ESTADUAL', 'POKPELE', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/179.png', NULL, NULL),
('90201', 'Cyndaquil', 'DEPUTADO ESTADUAL', 'POKPFGO', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/155.png', NULL, NULL),
('90301', 'Totodile', 'DEPUTADO ESTADUAL', 'POKPAGU', 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/158.png', NULL, NULL)
ON DUPLICATE KEY UPDATE `nome` = VALUES(`nome`), `partido` = VALUES(`partido`), `foto` = VALUES(`foto`);

-- 6. Votos de Demonstração (Permite ver a tela de apuração povoada imediatamente)
INSERT INTO `votos` (`cargo`, `numero_candidato`) VALUES
-- Presidente
('PRESIDENTE', '65'), ('PRESIDENTE', '65'), ('PRESIDENTE', '65'), ('PRESIDENTE', '65'), ('PRESIDENTE', '65'),
('PRESIDENTE', '63'), ('PRESIDENTE', '63'), ('PRESIDENTE', '63'), ('PRESIDENTE', '63'),
('PRESIDENTE', '62'), ('PRESIDENTE', '62'),
('PRESIDENTE', 'BRANCO'),
-- Governador
('GOVERNADOR', '81'), ('GOVERNADOR', '81'), ('GOVERNADOR', '81'), ('GOVERNADOR', '81'),
('GOVERNADOR', '85'), ('GOVERNADOR', '85'), ('GOVERNADOR', '85'),
('GOVERNADOR', '88'), ('GOVERNADOR', '88'),
-- 1º Senador
('1º SENADOR', '701'), ('1º SENADOR', '701'), ('1º SENADOR', '701'),
('1º SENADOR', '702'), ('1º SENADOR', '702'),
('1º SENADOR', '703'),
-- 2º Senador
('2º SENADOR', '751'), ('2º SENADOR', '751'), ('2º SENADOR', '751'), ('2º SENADOR', '751'),
('2º SENADOR', '752'), ('2º SENADOR', '752'),
-- Deputado Federal
('DEPUTADO FEDERAL', '9101'), ('DEPUTADO FEDERAL', '9101'), ('DEPUTADO FEDERAL', '9101'),
('DEPUTADO FEDERAL', '9201'), ('DEPUTADO FEDERAL', '9201'),
('DEPUTADO FEDERAL', '9301'),
-- Deputado Estadual
('DEPUTADO ESTADUAL', '90101'), ('DEPUTADO ESTADUAL', '90101'), ('DEPUTADO ESTADUAL', '90101'), ('DEPUTADO ESTADUAL', '90101'),
('DEPUTADO ESTADUAL', '90201'), ('DEPUTADO ESTADUAL', '90201');
SQL;

// Execução caso seja chamado diretamente (CLI ou Web)
$scriptAtual = basename($_SERVER['SCRIPT_FILENAME'] ?? $_SERVER['PHP_SELF'] ?? '');
if ($scriptAtual === 'seed.php') {
    header('Content-Type: text/plain; charset=utf-8');
    echo "=== [SEED] Executando Povoamento Inicial ===\n";
    try {
        $db = Conexao::getConexao();
        if ($db) {
            $db->exec($sqlSeed);
            echo "✔ Partidos, Candidatos e Votos inseridos com sucesso!\n";
        }
    } catch (PDOException $e) {
        echo "❌ Erro ao executar seed: " . $e->getMessage() . "\n";
    }
}
