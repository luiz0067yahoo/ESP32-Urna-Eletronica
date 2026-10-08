<?php
/**
 * Migração PHP Individual: Tabela 'candidatos'
 */
require_once __DIR__ . '/../../backend/conecta.php';

$sql = file_get_contents(__DIR__ . '/02_candidatos.sql');

if (basename(__FILE__) === basename($_SERVER['PHP_SELF'] ?? '')) {
    header('Content-Type: text/plain; charset=utf-8');
    echo "▶ Executando migração: tabela 'candidatos'...\n";
    try {
        $db = Conexao::getConexao();
        $db->exec($sql);
        echo "✔ Tabela 'candidatos' criada/verificada com sucesso!\n";
    } catch (Exception $e) {
        echo "❌ Erro ao criar tabela 'candidatos': " . $e->getMessage() . "\n";
    }
}
return $sql;
