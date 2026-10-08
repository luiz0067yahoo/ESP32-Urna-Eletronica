<?php
/**
 * Executor Geral de Migrações • Todas as Tabelas
 * Executa as migrações em ordem: partidos -> candidatos -> votos
 */
require_once __DIR__ . '/../../backend/conecta.php';

$sqlPartidos = require __DIR__ . '/partidos.php';
$sqlCandidatos = require __DIR__ . '/candidatos.php';
$sqlVotos = require __DIR__ . '/votos.php';

$todasMigracoes = [
    'partidos' => $sqlPartidos,
    'candidatos' => $sqlCandidatos,
    'votos' => $sqlVotos
];

$sqlCompleto = implode("\n\n", $todasMigracoes);
$resultados = [];

try {
    $db = Conexao::getConexao();
    foreach ($todasMigracoes as $tabela => $sql) {
        if ($db) {
            $db->exec($sql);
            $resultados[$tabela] = "OK (tabela pronta)";
        }
    }
} catch (Exception $e) {
    $resultados['erro'] = $e->getMessage();
}

if (basename(__FILE__) === basename($_SERVER['SCRIPT_FILENAME'] ?? $_SERVER['PHP_SELF'] ?? '')) {
    header('Content-Type: text/plain; charset=utf-8');
    echo "===================================================================\n";
    echo "   🛠️ EXECUÇÃO DE TODAS AS MIGRAÇÕES (100% PHP)\n";
    echo "===================================================================\n";
    foreach ($resultados as $k => $v) {
        echo " • Tabela {$k}: {$v}\n";
    }
    echo "===================================================================\n";
}

return $sqlCompleto;
