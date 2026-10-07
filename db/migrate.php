<?php
/**
 * Script de Migração do Banco de Dados
 * Execução: php db/migrate.php ou via navegador
 */

require_once __DIR__ . '/../backend/conecta.php';

header('Content-Type: text/plain; charset=utf-8');

echo "=== [MIGRATE] Iniciando Migração do Banco de Dados ===\n";

try {
    $db = Conexao::getConexao();
    if (!$db) {
        throw new Exception("Falha ao obter conexão com o banco de dados.");
    }

    $sqlFile = __DIR__ . '/migrate.sql';
    if (!file_exists($sqlFile)) {
        throw new Exception("Arquivo migrate.sql não encontrado em {$sqlFile}");
    }

    $sqlContent = file_get_contents($sqlFile);
    
    // Executa as instruções SQL
    $db->exec($sqlContent);

    echo "✔ Tabelas 'votos', 'partidos' e 'candidatos' verificadas e criadas com sucesso!\n";
    echo "=== Migração concluída com sucesso! ===\n";

} catch (Exception $e) {
    echo "❌ Erro durante a migração: " . $e->getMessage() . "\n";
    exit(1);
}
