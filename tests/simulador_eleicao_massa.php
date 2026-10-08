<?php
/**
 * =============================================================================
 * ⚡ SIMULADOR DE ELEIÇÃO EM MASSA • TESTE DE CARGA & ESTRESSE (100% PHP)
 * Urna Eletrônica Pokémon • Eleições 2026
 * =============================================================================
 * Simula dezenas ou centenas de eleitores votando em paralelo:
 * - Utiliza curl_multi para disparos assíncronos concorrentes de alto desempenho
 * - Métricas de RPS (votos por segundo), latência média, taxa de sucesso
 * =============================================================================
 */

$isCli = (php_sapi_name() === 'cli');

$qtdEleitores = 50;
$concorrencia = 10;
$apiUrl = "http://localhost:8080/backend/votos";

if ($isCli) {
    if (isset($argv[1]) && is_numeric($argv[1])) $qtdEleitores = (int)$argv[1];
    if (isset($argv[2]) && is_numeric($argv[2])) $concorrencia = (int)$argv[2];
    if (isset($argv[3]) && !empty($argv[3])) $apiUrl = $argv[3];
} else {
    if (isset($_GET['eleitores'])) $qtdEleitores = (int)$_GET['eleitores'];
    if (isset($_GET['concorrencia'])) $concorrencia = (int)$_GET['concorrencia'];
    if (isset($_GET['url'])) $apiUrl = $_GET['url'];
    header('Content-Type: text/plain; charset=utf-8');
}

$candidatos = [
    "DEPUTADO ESTADUAL" => ["90101", "90102", "90201", "90301"],
    "DEPUTADO FEDERAL"  => ["9101", "9102", "9201", "9301"],
    "1º SENADOR"        => ["701", "702", "703"],
    "2º SENADOR"        => ["751", "752", "753"],
    "GOVERNADOR"        => ["81", "82", "84", "85", "87", "88"],
    "PRESIDENTE"        => ["65", "63", "62"]
];

$totalVotosEsperados = $qtdEleitores * count($candidatos);

echo "=====================================================================\n";
echo "   ⚡ SIMULADOR DE CARGA E ESTRESSE DA API (100% PHP)\n";
echo "=====================================================================\n";
echo " Endpoint:           {$apiUrl}\n";
echo " Total de Eleitores: {$qtdEleitores}\n";
echo " Cargos por Eleitor: " . count($candidatos) . "\n";
echo " Votos a Processar:  {$totalVotosEsperados}\n";
echo " Concorrência:       {$concorrencia} requisições simultâneas\n";
echo "=====================================================================\n\n";

echo "▶ Disparando requisições assíncronas...\n";
$inicioGeral = microtime(true);

$votosEnviados = 0;
$votosSucesso = 0;
$votosFalha = 0;
$tempos = [];

// Gera lista de todos os votos a enviar
$filaVotos = [];
for ($e = 1; $e <= $qtdEleitores; $e++) {
    foreach ($candidatos as $cargo => $nums) {
        $sorteio = mt_rand(1, 100);
        if ($sorteio <= 8) {
            $num = "BRANCO";
        } elseif ($sorteio <= 14) {
            $num = "00";
        } else {
            $num = $nums[array_rand($nums)];
        }
        $filaVotos[] = [
            "eleitor" => $e,
            "cargo" => $cargo,
            "numero_candidato" => $num
        ];
    }
}

// Processa a fila usando lotes com curl_multi
$chunks = array_chunk($filaVotos, $concorrencia);

foreach ($chunks as $chunkIndex => $chunk) {
    if (function_exists('curl_multi_init')) {
        $mh = curl_multi_init();
        $curlHandles = [];

        foreach ($chunk as $voto) {
            $ch = curl_init($apiUrl);
            $payload = json_encode([
                "cargo" => $voto["cargo"],
                "numero_candidato" => $voto["numero_candidato"]
            ]);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
            curl_setopt($ch, CURLOPT_TIMEOUT, 6);
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                "Content-Type: application/json",
                "User-Agent: CargaPHP-Urna/2.0"
            ]);
            curl_multi_add_handle($mh, $ch);
            $curlHandles[] = $ch;
        }

        $active = null;
        $t0Lote = microtime(true);
        do {
            $mrc = curl_multi_exec($mh, $active);
        } while ($mrc === CURLM_CALL_MULTI_PER_FORM || $active);

        $duracaoLote = (microtime(true) - $t0Lote) * 1000;

        foreach ($curlHandles as $ch) {
            $code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $votosEnviados++;
            $tempos[] = $duracaoLote;
            if ($code === 200 || $code === 201) {
                $votosSucesso++;
            } else {
                $votosFalha++;
            }
            curl_multi_remove_handle($mh, $ch);
            curl_close($ch);
        }
        curl_multi_close($mh);
    } else {
        // Fallback síncrono
        foreach ($chunk as $voto) {
            $payload = json_encode([
                "cargo" => $voto["cargo"],
                "numero_candidato" => $voto["numero_candidato"]
            ]);
            $opts = ['http' => ['method' => 'POST', 'timeout' => 4, 'header' => "Content-Type: application/json\r\n", 'content' => $payload]];
            $t0 = microtime(true);
            $res = @file_get_contents($apiUrl, false, stream_context_create($opts));
            $ms = (microtime(true) - $t0) * 1000;
            $votosEnviados++;
            $tempos[] = $ms;
            if ($res !== false) $votosSucesso++; else $votosFalha++;
        }
    }

    $progresso = ($votosEnviados / $totalVotosEsperados) * 100;
    if ($votosEnviados % 30 === 0 || $votosEnviados === $totalVotosEsperados) {
        printf("  [Progresso: %5.1f%%] %d / %d votos processados\n", $progresso, $votosEnviados, $totalVotosEsperados);
    }
}

$duracaoTotal = microtime(true) - $inicioGeral;
$rps = $duracaoTotal > 0 ? ($votosEnviados / $duracaoTotal) : 0;
$mediaLatencia = count($tempos) > 0 ? (array_sum($tempos) / count($tempos)) : 0;
$taxaSucesso = $votosEnviados > 0 ? (($votosSucesso / $votosEnviados) * 100) : 0;

echo "\n=====================================================================\n";
echo " 📊 RESULTADOS DO TESTE DE CARGA:\n";
echo "   • Votos Processados: {$votosEnviados} / {$totalVotosEsperados}\n";
echo "   • Votos com Sucesso: {$votosSucesso} (" . number_format($taxaSucesso, 1) . "%)\n";
echo "   • Votos com Falha:   {$votosFalha}\n";
echo "   • Tempo Total:       " . number_format($duracaoTotal, 2) . " segundos\n";
echo "   • Vazão Média (RPS): " . number_format($rps, 1) . " votos/segundo\n";
echo "   • Latência Média:    " . number_format($mediaLatencia, 1) . " ms por requisição\n";
echo "=====================================================================\n";
if ($taxaSucesso >= 95) {
    echo " ✔ A API suportou a carga de estresse com alto desempenho!\n\n";
} else {
    echo " ⚠️ A taxa de sucesso foi abaixo do ideal. Verifique os logs do servidor.\n\n";
}
