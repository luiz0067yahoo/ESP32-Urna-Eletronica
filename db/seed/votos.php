<?php
/**
 * Povoamento PHP Individual: Tabela 'votos' (Demonstração Inicial)
 */
require_once __DIR__ . '/../../backend/conecta.php';

$sql = file_get_contents(__DIR__ . '/03_votos.sql');

if (basename(__FILE__) === basename($_SERVER['PHP_SELF'] ?? '')) {
    header('Content-Type: text/plain; charset=utf-8');
    echo "▶ Executando seed: votos de demonstração...\n";
    try {
        $db = Conexao::getConexao();
        $db->exec($sql);
        echo "✔ Votos de demonstração semeados com sucesso!\n";
    } catch (Exception $e) {
        echo "❌ Erro ao semear votos: " . $e->getMessage() . "\n";
    }
}
return $sql;
