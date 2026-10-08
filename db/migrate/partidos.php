<?php
/**
 * Migração PHP Individual: Tabela 'partidos'
 */
require_once __DIR__ . '/../../backend/conecta.php';

$sql = file_get_contents(__DIR__ . '/01_partidos.sql');

if (basename(__FILE__) === basename($_SERVER['PHP_SELF'] ?? '')) {
    header('Content-Type: text/plain; charset=utf-8');
    echo "▶ Executando migração: tabela 'partidos'...\n";
    try {
        $db = Conexao::getConexao();
        $db->exec($sql);
        echo "✔ Tabela 'partidos' criada/verificada com sucesso!\n";
    } catch (Exception $e) {
        echo "❌ Erro ao criar tabela 'partidos': " . $e->getMessage() . "\n";
    }
}
return $sql;
