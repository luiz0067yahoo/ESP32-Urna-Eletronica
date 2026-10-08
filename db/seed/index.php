<?php
/**
 * Executor Geral de Povoamento (Seed) • Todas as Tabelas
 * Executa todos os seeds em ordem: partidos -> candidatos -> votos
 */
require_once __DIR__ . '/../../backend/conecta.php';

$sqlSeedPartidos = require __DIR__ . '/partidos.php';
$sqlSeedCandidatos = require __DIR__ . '/candidatos.php';
$sqlSeedVotos = require __DIR__ . '/votos.php';

$todosSeeds = [
    'partidos' => $sqlSeedPartidos,
    'candidatos' => $sqlSeedCandidatos,
    'votos' => $sqlSeedVotos
];

$sqlCompleto = implode("\n\n", $todosSeeds);
$resultados = [];

try {
    $db = Conexao::getConexao();
    foreach ($todosSeeds as $tabela => $sql) {
        if ($db) {
            $db->exec($sql);
            $resultados[$tabela] = "OK (dados semeados)";
        }
    }
} catch (Exception $e) {
    $resultados['erro'] = $e->getMessage();
}

if (basename(__FILE__) === basename($_SERVER['SCRIPT_FILENAME'] ?? $_SERVER['PHP_SELF'] ?? '')) {
    header('Content-Type: text/plain; charset=utf-8');
    echo "===================================================================\n";
    echo "   🌱 EXECUÇÃO DE TODOS OS SEEDS (100% PHP)\n";
    echo "===================================================================\n";
    foreach ($resultados as $k => $v) {
        echo " • Tabela {$k}: {$v}\n";
    }
    echo "===================================================================\n";
}

return $sqlCompleto;
