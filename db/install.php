<?php
/**
 * Instalador Inteligente do Banco de Dados - Urna Eletrônica Pokémon
 * Verifica se o banco já foi migrado e se o seed já foi cadastrado antes de executar.
 * Execução: php db/install.php ou via navegador em http://localhost/db/install.php
 */

require_once __DIR__ . '/../backend/conecta.php';
require_once __DIR__ . '/migrate.php';
require_once __DIR__ . '/seed.php';

$isCli = (php_sapi_name() === 'cli');
$wantsJson = isset($_GET['format']) && strtolower($_GET['format']) === 'json';

if ($isCli || !$wantsJson) {
    header('Content-Type: text/plain; charset=utf-8');
} else {
    header('Content-Type: application/json; charset=utf-8');
}

$resultado = [
    "status" => "success",
    "timestamp" => date("Y-m-d H:i:s"),
    "migracao" => [
        "executada" => false,
        "ja_existia" => false,
        "mensagem" => ""
    ],
    "seed" => [
        "executado" => false,
        "ja_existia" => false,
        "mensagem" => ""
    ],
    "totais" => [
        "partidos" => 0,
        "candidatos" => 0,
        "votos" => 0
    ]
];

function logMensagem($msg, $isCli) {
    echo $msg . "\n";
}

if (!$wantsJson) {
    echo "===================================================================\n";
    echo "   🗳️ INSTALADOR DO BANCO DE DADOS • URNA ELETRÔNICA POKÉMON\n";
    echo "===================================================================\n\n";
}

try {
    // 1. Obtém a conexão com o banco de dados
    $db = Conexao::getConexao();
    if (!$db) {
        throw new Exception("Não foi possível conectar ao banco de dados MySQL.");
    }

    // 2. VERIFICAÇÃO DA MIGRAÇÃO (Estrutura das Tabelas)
    if (!$wantsJson) echo "1. Verificando estrutura das tabelas (Migração)...\n";

    $tabelasNecessarias = ['votos', 'partidos', 'candidatos'];
    $tabelasExistentes = [];

    foreach ($tabelasNecessarias as $tab) {
        $stmt = $db->query("SHOW TABLES LIKE '{$tab}'");
        if ($stmt && $stmt->rowCount() > 0) {
            $tabelasExistentes[] = $tab;
        }
    }

    $todasTabelasExistem = (count($tabelasExistentes) === count($tabelasNecessarias));

    if ($todasTabelasExistem) {
        $resultado["migracao"]["ja_existia"] = true;
        $resultado["migracao"]["mensagem"] = "As tabelas ('votos', 'partidos', 'candidatos') já estão criadas no banco.";
        if (!$wantsJson) echo "   ℹ️ Migração já realizada anteriormente! Tabelas já existem.\n";
    } else {
        // Executa a migração contida na string $sqlMigrate
        $db->exec($sqlMigrate);
        $resultado["migracao"]["executada"] = true;
        $resultado["migracao"]["mensagem"] = "Migração executada com sucesso! Tabelas criadas.";
        if (!$wantsJson) echo "   ✔ Migração executada! Tabelas criadas com sucesso.\n";
    }

    // 3. VERIFICAÇÃO DO SEED (Povoamento de Partidos e Candidatos)
    if (!$wantsJson) echo "\n2. Verificando dados iniciais (Seed de Candidatos e Partidos)...\n";

    $qtdPartidos = (int)$db->query("SELECT COUNT(*) FROM partidos")->fetchColumn();
    $qtdCandidatos = (int)$db->query("SELECT COUNT(*) FROM candidatos")->fetchColumn();
    $qtdVotos = (int)$db->query("SELECT COUNT(*) FROM votos")->fetchColumn();

    $jaTemSeed = ($qtdPartidos > 0 && $qtdCandidatos > 0);

    if ($jaTemSeed) {
        $resultado["seed"]["ja_existia"] = true;
        $resultado["seed"]["mensagem"] = "Seed já cadastrado ({$qtdCandidatos} candidatos e {$qtdPartidos} partidos encontrados).";
        if (!$wantsJson) echo "   ℹ️ Seed já cadastrado anteriormente! ({$qtdCandidatos} candidatos e {$qtdPartidos} partidos já no banco).\n";
    } else {
        // Executa o seed contido na string $sqlSeed
        $db->exec($sqlSeed);
        $qtdPartidos = (int)$db->query("SELECT COUNT(*) FROM partidos")->fetchColumn();
        $qtdCandidatos = (int)$db->query("SELECT COUNT(*) FROM candidatos")->fetchColumn();
        $qtdVotos = (int)$db->query("SELECT COUNT(*) FROM votos")->fetchColumn();

        $resultado["seed"]["executado"] = true;
        $resultado["seed"]["mensagem"] = "Seed executado com sucesso! ({$qtdCandidatos} candidatos e {$qtdPartidos} partidos inseridos).";
        if (!$wantsJson) echo "   ✔ Seed cadastrado com sucesso! ({$qtdCandidatos} candidatos e {$qtdPartidos} partidos inseridos).\n";
    }

    $resultado["totais"]["partidos"] = $qtdPartidos;
    $resultado["totais"]["candidatos"] = $qtdCandidatos;
    $resultado["totais"]["votos"] = $qtdVotos;

    if (!$wantsJson) {
        echo "\n===================================================================\n";
        echo "   📊 RESUMO ATUAL DO BANCO DE DADOS:\n";
        echo "   • Partidos Cadastrados: {$qtdPartidos}\n";
        echo "   • Candidatos Cadastrados: {$qtdCandidatos}\n";
        echo "   • Votos Registrados: {$qtdVotos}\n";
        echo "===================================================================\n";
        echo "   ✔ Status: BANCO DE DADOS PRONTO PARA USO!\n";
        echo "   👉 Urna: http://localhost:8080/frontend/index.html\n";
        echo "   👉 Apuração: http://localhost:8080/frontend/apuracao.html\n";
        echo "===================================================================\n";
    } else {
        echo json_encode($resultado, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
    }

} catch (Exception $e) {
    if ($wantsJson) {
        http_response_code(500);
        echo json_encode([
            "status" => "error",
            "message" => $e->getMessage()
        ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
    } else {
        echo "\n❌ ERRO NA INSTALAÇÃO: " . $e->getMessage() . "\n";
    }
    exit(1);
}
