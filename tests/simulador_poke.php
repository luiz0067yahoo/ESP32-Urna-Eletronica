<?php
/**
 * =============================================================================
 * 🗳️ SIMULADOR DE TERMINAL ELEITORAL DIGITAL (100% PHP)
 * Urna Eletrônica Pokémon • Eleições 2026
 * =============================================================================
 * Emula a operação do terminal de votação da Urna Eletrônica:
 * - Entrada de votos por teclado digital
 * - Transmissão de votos via HTTP POST para a API REST (/backend/votos)
 * - Simulação de votação de eleitor completo (6 cargos em sequência)
 * - Votação aleatória, nominal, em branco ou nula
 * - Medição de latência por voto computado
 * =============================================================================
 */

$isCli = (php_sapi_name() === 'cli');

$defaultApiUrl = "http://localhost:8080/backend/votos";
$apiUrl = $defaultApiUrl;

if ($isCli && isset($argv[1]) && !empty($argv[1])) {
    $apiUrl = $argv[1];
}

$candidatosPoke = [
    "DEPUTADO ESTADUAL" => [
        ["numero" => "90101", "nome" => "Pichu (POKPELE)"],
        ["numero" => "90102", "nome" => "Mareep (POKPELE)"],
        ["numero" => "90201", "nome" => "Cyndaquil (POKPFGO)"],
        ["numero" => "90301", "nome" => "Totodile (POKPAGU)"]
    ],
    "DEPUTADO FEDERAL" => [
        ["numero" => "9101", "nome" => "Raichu (POKPELE)"],
        ["numero" => "9102", "nome" => "Jolteon (POKPELE)"],
        ["numero" => "9201", "nome" => "Charizard (POKPFGO)"],
        ["numero" => "9301", "nome" => "Blastoise (POKPAGU)"]
    ],
    "1º SENADOR" => [
        ["numero" => "701", "nome" => "Alakazam (POKPPSI)"],
        ["numero" => "702", "nome" => "Gengar (POKPFAN)"],
        ["numero" => "703", "nome" => "Dragonite (POKPDRA)"]
    ],
    "2º SENADOR" => [
        ["numero" => "751", "nome" => "Mewtwo (POKPPSI)"],
        ["numero" => "752", "nome" => "Lugia (POKPPSI)"],
        ["numero" => "753", "nome" => "Ho-Oh (POKPFGO)"]
    ],
    "GOVERNADOR" => [
        ["numero" => "81", "nome" => "Manectric (POKPELE)"],
        ["numero" => "82", "nome" => "Zapdos (POKPELE)"],
        ["numero" => "84", "nome" => "Magmortar (POKPFGO)"],
        ["numero" => "85", "nome" => "Blaziken (POKPFGO)"],
        ["numero" => "87", "nome" => "Feraligatr (POKPAGU)"],
        ["numero" => "88", "nome" => "Greninja (POKPAGU)"]
    ],
    "PRESIDENTE" => [
        ["numero" => "65", "nome" => "Pikachu & Totodile (POKPELE)"],
        ["numero" => "63", "nome" => "Squirtle & Bulbasaur (POKPAGU)"],
        ["numero" => "62", "nome" => "Charmander & Flareon (POKPFGO)"]
    ]
];

function logTerminal($msg) {
    $time = date("H:i:s");
    echo "[URNA | {$time}] {$msg}\n";
}

function buzzerBip($tipo = "curto") {
    $sons = [
        "curto" => "🔊 *BIP* (440Hz)",
        "corrige" => "🔊 *BOP-BOP* (220Hz)",
        "fim" => "🔊 🎶 *TU-TU-TU-TURUUUUUU* (Sinal TSE • VOTAÇÃO FINALIZADA!)"
    ];
    echo "      " . ($sons[$tipo] ?? "🔊 *BIP*") . "\n";
}

function enviarVotoHttp($apiUrl, $cargo, $numero, $secao = "001") {
    $payload = json_encode([
        "cargo" => $cargo,
        "numero_candidato" => (string)$numero
    ]);

    $t0 = microtime(true);

    if (function_exists('curl_init')) {
        $ch = curl_init($apiUrl);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
        curl_setopt($ch, CURLOPT_TIMEOUT, 5);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            "Content-Type: application/json",
            "User-Agent: TerminalUrna-ClientePHP/2.0",
            "X-Secao-Eleitoral: {$secao}"
        ]);
        $response = curl_exec($ch);
        $status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $duracao = (microtime(true) - $t0) * 1000;
        curl_close($ch);
        return [$status === 200 || $status === 201, $status, $duracao, $response];
    } else {
        $opts = [
            'http' => [
                'method' => 'POST',
                'timeout' => 5,
                'ignore_errors' => true,
                'header' => "Content-Type: application/json\r\nUser-Agent: TerminalUrna-ClientePHP/2.0\r\nX-Secao-Eleitoral: {$secao}\r\n",
                'content' => $payload
            ]
        ];
        $ctx = stream_context_create($opts);
        $response = @file_get_contents($apiUrl, false, $ctx);
        $status = 0;
        if (isset($http_response_header[0])) {
            preg_match('/HTTP\/\S*\s(\d{3})/', $http_response_header[0], $m);
            $status = isset($m[1]) ? (int)$m[1] : 0;
        }
        $duracao = (microtime(true) - $t0) * 1000;
        return [$status === 200 || $status === 201, $status, $duracao, $response];
    }
}

function simularEleitorCompleto($apiUrl, $candidatosPoke, $escolha = "random") {
    logTerminal("▶ Eleitor liberado pelo mesário. Iniciando votação...");
    $cargos = array_keys($candidatosPoke);

    foreach ($cargos as $cargo) {
        $opcoes = $candidatosPoke[$cargo];
        if ($escolha === "branco") {
            $num = "BRANCO";
            $nome = "VOTO EM BRANCO";
        } elseif ($escolha === "nulo") {
            $num = "00";
            $nome = "VOTO NULO";
        } else {
            $rand = mt_rand(1, 100);
            if ($rand <= 8) {
                $num = "BRANCO";
                $nome = "VOTO EM BRANCO";
            } elseif ($rand <= 15) {
                $num = "00";
                $nome = "VOTO NULO";
            } else {
                $c = $opcoes[array_rand($opcoes)];
                $num = $c["numero"];
                $nome = $c["nome"];
            }
        }

        logTerminal("Cargo: {$cargo} -> Digitado '{$num}' ({$nome})");
        buzzerBip("curto");
        usleep(100000);

        logTerminal("Eleitor pressionou [CONFIRMA]");
        buzzerBip("curto");

        list($ok, $st, $ms, $resp) = enviarVotoHttp($apiUrl, $cargo, $num);
        $msFmt = number_format($ms, 1);
        if ($ok) {
            logTerminal("   ✔ Voto computado na API! HTTP {$st} ({$msFmt}ms)");
        } else {
            logTerminal("   ⚠️ Falha ao registrar ({$msFmt}ms): Status={$st}");
        }
        usleep(150000);
    }

    echo "\n-----------------------------------------------------------------\n";
    logTerminal("🎉 VOTAÇÃO CONCLUÍDA PARA TODOS OS 6 CARGOS!");
    buzzerBip("fim");
    echo "-----------------------------------------------------------------\n\n";
}

// Execução
echo "\n=================================================================\n";
echo "  🗳️ TERMINAL ELEITORAL DIGITAL • CABINE DE VOTAÇÃO (100% PHP)\n";
echo "=================================================================\n";
echo " Endpoint: {$apiUrl}\n";
echo "=================================================================\n\n";

if ($isCli && isset($argv[2]) && $argv[2] === '--auto') {
    simularEleitorCompleto($apiUrl, $candidatosPoke, "random");
} elseif ($isCli) {
    echo "Opções de simulação:\n";
    echo " 1. Simular 1 Eleitor Completo (6 cargos - Aleatório)\n";
    echo " 2. Simular 1 Eleitor Votando BRANCO em tudo\n";
    echo " 3. Simular 1 Eleitor Votando NULO em tudo\n";
    echo " 0. Sair\n\n";
    echo "Digite a opção desejada (0-3): ";
    $linha = trim(fgets(STDIN));

    if ($linha === "1") {
        simularEleitorCompleto($apiUrl, $candidatosPoke, "random");
    } elseif ($linha === "2") {
        simularEleitorCompleto($apiUrl, $candidatosPoke, "branco");
    } elseif ($linha === "3") {
        simularEleitorCompleto($apiUrl, $candidatosPoke, "nulo");
    } else {
        echo "Operação finalizada.\n";
    }
} else {
    // Via Navegador
    simularEleitorCompleto($apiUrl, $candidatosPoke, "random");
}
