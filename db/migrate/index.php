<?php
/**
 * Executor Geral de Migrações • Todas as Tabelas
 * Executa todas as migrações SQL em ordem: partidos -> candidatos -> votos
 */
require_once __DIR__ . '/../../backend/conecta.php';

$arquivosMigracao = [
    'partidos'   => __DIR__ . '/01_partidos.sql',
    'candidatos' => __DIR__ . '/02_candidatos.sql',
    'votos'      => __DIR__ . '/03_votos.sql'
];

$sqlCompleto = '';
$resultados = [];

try {
    $db = Conexao::getConexao();
    foreach ($arquivosMigracao as $tabela => $caminho) {
        if (file_exists($caminho)) {
            $sqlTabela = file_get_contents($caminho);
            $sqlCompleto .= $sqlTabela . "\n\n";
            if ($db) {
                $db->exec($sqlTabela);
                $resultados[$tabela] = "OK (criada ou verificada)";
            }
        }
    }
} catch (Exception $e) {
    $resultados['erro'] = $e->getMessage();
}

if (basename(__FILE__) === basename($_SERVER['PHP_SELF'] ?? '')) {
    header('Content-Type: text/plain; charset=utf-8');
    echo "===================================================================\n";
    echo "   🛠️ EXECUÇÃO GERAL DE MIGRAÇÕES • BANCO DE DADOS\n";
    echo "===================================================================\n";
    foreach ($resultados as $k => $v) {
        echo " • {$k}: {$v}\n";
    }
    echo "===================================================================\n";
}

$sqlMigrate = $sqlCompleto;
return $sqlCompleto;
