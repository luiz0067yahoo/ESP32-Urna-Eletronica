<?php
/**
 * Povoamento PHP Individual: Tabela 'partidos'
 */
require_once __DIR__ . '/../../backend/conecta.php';

$sqlSeedPartidos = <<<SQL
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
SQL;

if (basename(__FILE__) === basename($_SERVER['SCRIPT_FILENAME'] ?? $_SERVER['PHP_SELF'] ?? '')) {
    header('Content-Type: text/plain; charset=utf-8');
    echo "▶ Executando seed da tabela 'partidos'...\n";
    try {
        $db = Conexao::getConexao();
        if ($db) {
            $db->exec($sqlSeedPartidos);
            echo "✔ Partidos semeados com sucesso!\n";
        }
    } catch (Exception $e) {
        echo "❌ Erro ao semear partidos: " . $e->getMessage() . "\n";
    }
}

return $sqlSeedPartidos;
