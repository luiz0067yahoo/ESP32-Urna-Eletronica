<?php
/**
 * Script de Seed (Povoamento Inicial) do Banco de Dados
 * Execução: php db/seed.php ou via navegador
 */

require_once __DIR__ . '/../backend/conecta.php';

header('Content-Type: text/plain; charset=utf-8');

echo "=== [SEED] Iniciando Povoamento Inicial do Banco de Dados ===\n";

try {
    $db = Conexao::getConexao();
    if (!$db) {
        throw new Exception("Falha ao obter conexão com o banco de dados.");
    }

    $sqlFile = __DIR__ . '/seed.sql';
    if (!file_exists($sqlFile)) {
        throw new Exception("Arquivo seed.sql não encontrado em {$sqlFile}");
    }

    $sqlContent = file_get_contents($sqlFile);
    
    // Executa as instruções SQL do seed
    $db->exec($sqlContent);

    // Contagem de registros inseridos
    $totalPartidos = $db->query("SELECT COUNT(*) FROM partidos")->fetchColumn();
    $totalCandidatos = $db->query("SELECT COUNT(*) FROM candidatos")->fetchColumn();
    $totalVotos = $db->query("SELECT COUNT(*) FROM votos")->fetchColumn();

    echo "✔ Partidos cadastrados: {$totalPartidos}\n";
    echo "✔ Candidatos cadastrados: {$totalCandidatos}\n";
    echo "✔ Votos de demonstração registrados: {$totalVotos}\n";
    echo "=== Povoamento concluído com sucesso! ===\n";

} catch (Exception $e) {
    echo "❌ Erro durante o seed: " . $e->getMessage() . "\n";
    exit(1);
}
