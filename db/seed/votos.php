<?php
/**
 * Povoamento PHP Individual: Tabela 'votos' (Demonstração Inicial)
 */
require_once __DIR__ . '/../../backend/conecta.php';

$sqlSeedVotos = <<<SQL
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

if (basename(__FILE__) === basename($_SERVER['SCRIPT_FILENAME'] ?? $_SERVER['PHP_SELF'] ?? '')) {
    header('Content-Type: text/plain; charset=utf-8');
    echo "▶ Executando seed de votos de demonstração...\n";
    try {
        $db = Conexao::getConexao();
        if ($db) {
            $db->exec($sqlSeedVotos);
            echo "✔ Votos de demonstração semeados com sucesso!\n";
        }
    } catch (Exception $e) {
        echo "❌ Erro ao semear votos: " . $e->getMessage() . "\n";
    }
}

return $sqlSeedVotos;
