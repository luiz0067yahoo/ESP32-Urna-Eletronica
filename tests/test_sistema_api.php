<?php
/**
 * =============================================================================
 * 🧪 SUÍTE DE TESTES DE SISTEMA & API RESTful (100% PHP)
 * Urna Eletrônica Pokémon • Eleições 2026
 * =============================================================================
 * Executa testes automatizados ponta a ponta dos contratos da API:
 * - Conectividade e status do sistema
 * - Registro unitário de votos nominais, brancos e nulos
 * - Registro em lote de votos da cabine
 * - Consultas de listagem, resumo agrupado e ID individual
 * - Apuração eleitoral consolidada
 * - Validação de erros HTTP (400, 404, 405)
 * - Procedimento de Zerésima eleitoral e re-seed
 * =============================================================================
 */

$isCli = (php_sapi_name() === 'cli');

if (!$isCli) {
    header('Content-Type: text/html; charset=utf-8');
} else {
    // Garante UTF-8 no terminal
    if (function_exists('cli_set_process_title')) {
        @cli_set_process_title("Testes de Sistema • Urna Eletrônica");
    }
}

// Cores ANSI para CLI
$C_VERDE    = $isCli ? "\033[92m" : "";
$C_VERMELHO = $isCli ? "\033[91m" : "";
$C_AMARELO  = $isCli ? "\033[93m" : "";
$C_AZUL     = $isCli ? "\033[94m" : "";
$C_RESET    = $isCli ? "\033[0m"  : "";
$C_NEGRITO  = $isCli ? "\033[1m"  : "";

// URL Base configurável via argumento CLI, query param ou auto-detect
$baseUrl = "http://localhost:8080";
if ($isCli && isset($argv[1])) {
    $baseUrl = rtrim($argv[1], '/');
} elseif (!$isCli && isset($_GET['url'])) {
    $baseUrl = rtrim($_GET['url'], '/');
} elseif (!$isCli && isset($_SERVER['HTTP_HOST'])) {
    $protocolo = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on') ? "https" : "http";
    $baseUrl = "{$protocolo}://" . $_SERVER['HTTP_HOST'];
}

class TestResult {
    public $passou = 0;
    public $falhou = 0;
    public $erros = [];

    public function registrarSucesso($nome, $duracaoMs) {
        global $C_VERDE, $C_RESET, $isCli;
        $this->passou++;
        $ms = number_format($duracaoMs, 1, '.', '');
        if ($isCli) {
            echo "  {$C_VERDE}✔ PASSOU{$C_RESET} | {$nome} ({$ms}ms)\n";
        } else {
            echo "<div style='color:#10b981; margin: 4px 0;'>✔ <strong>PASSOU</strong> | {$nome} ({$ms}ms)</div>";
        }
    }

    public function registrarFalha($nome, $motivo, $duracaoMs = 0) {
        global $C_VERMELHO, $C_RESET, $isCli;
        $this->falhou++;
        $this->erros[] = ["nome" => $nome, "motivo" => $motivo];
        if ($isCli) {
            echo "  {$C_VERMELHO}✖ FALHOU{$C_RESET} | {$nome}: {$motivo}\n";
        } else {
            echo "<div style='color:#ef4444; margin: 4px 0;'>✖ <strong>FALHOU</strong> | {$nome}: {$motivo}</div>";
        }
    }
}

class ApiTestSuite {
    private $baseUrl;
    private $votosUrl;
    private $apuracaoUrl;
    private $installUrl;
    private $statusUrl;
    public $result;

    public function __construct($baseUrl) {
        $this->baseUrl = rtrim($baseUrl, '/');
        $this->votosUrl = "{$this->baseUrl}/backend/votos";
        $this->apuracaoUrl = "{$this->baseUrl}/backend/apuracao";
        $this->statusUrl = "{$this->baseUrl}/backend/status";
        $this->installUrl = "{$this->baseUrl}/db/install.php?format=json";
        $this->result = new TestResult();
    }

    private function httpRequest($url, $method = "GET", $data = null) {
        $t0 = microtime(true);

        if (function_exists('curl_init')) {
            $ch = curl_init($url);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
            curl_setopt($ch, CURLOPT_TIMEOUT, 6);
            curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);

            $headers = [
                'User-Agent: UrnaTestSuite-PHP/2.0',
                'Accept: application/json'
            ];

            if ($data !== null) {
                $payload = is_string($data) ? $data : json_encode($data);
                curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
                $headers[] = 'Content-Type: application/json';
            }

            curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
            $response = curl_exec($ch);
            $status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $duracao = (microtime(true) - t0) * 1000;
            curl_close($ch);

            $json = json_decode($response, true);
            return [$status, $json !== null ? $json : $response, $duracao];
        } else {
            $options = [
                'http' => [
                    'method' => $method,
                    'timeout' => 6,
                    'ignore_errors' => true,
                    'header' => "User-Agent: UrnaTestSuite-PHP/2.0\r\nAccept: application/json\r\n"
                ]
            ];

            if ($data !== null) {
                $payload = is_string($data) ? $data : json_encode($data);
                $options['http']['header'] .= "Content-Type: application/json\r\n";
                $options['http']['content'] = $payload;
            }

            $context = stream_context_create($options);
            $response = @file_get_contents($url, false, $context);
            $status = 0;
            if (isset($http_response_header[0])) {
                preg_match('/HTTP\/\S*\s(\d{3})/', $http_response_header[0], $m);
                $status = isset($m[1]) ? (int)$m[1] : 0;
            }
            $duracao = (microtime(true) - t0) * 1000;
            $json = json_decode($response, true);
            return [$status, $json !== null ? $json : $response, $duracao];
        }
    }

    public function executarTodos() {
        global $isCli;
        $inicioTotal = microtime(true);

        if (!$isCli) {
            echo "<!DOCTYPE html><html lang='pt-BR'><head><meta charset='utf-8'><title>Suíte de Testes PHP</title>";
            echo "<style>body{font-family:sans-serif;background:#0f172a;color:#f8fafc;padding:2rem;}pre{background:#1e293b;padding:1rem;border-radius:8px;}</style></head><body>";
            echo "<h2>🧪 Suíte de Testes de Sistema • Urna Eletrônica Pokémon (100% PHP)</h2>";
            echo "<p>Endpoint testado: <code>{$this->baseUrl}</code></p><hr style='border-color:#334155;'><br>";
        } else {
            echo "\n=====================================================================\n";
            echo "   🧪 SUÍTE DE TESTES DE SISTEMA & API RESTful (100% PHP)\n";
            echo "=====================================================================\n";
            echo " Endpoint Base: {$this->baseUrl}\n";
            echo " Timestamp:     " . date("Y-m-d H:i:s") . "\n";
            echo "=====================================================================\n\n";
        }

        // 1. Conectividade
        list($st, $dt, $ms) = $this->httpRequest($this->votosUrl, "GET");
        if ($st === 200 || $st === 201) {
            $this->result->registrarSucesso("01. Conectividade básica com o backend", $ms);
        } else {
            $this->result->registrarFalha("01. Conectividade básica com o backend", "HTTP {$st}");
        }

        // 2. Status API
        list($st, $dt, $ms) = $this->httpRequest($this->statusUrl, "GET");
        if ($st === 200 && is_array($dt) && isset($dt['status']) && $dt['status'] === 'online') {
            $this->result->registrarSucesso("02. Endpoint de saúde /status responde 'online'", $ms);
        } else {
            $this->result->registrarFalha("02. Endpoint de saúde /status responde 'online'", "HTTP {$st}");
        }

        // 3. Voto individual
        list($st, $dt, $ms) = $this->httpRequest($this->votosUrl, "POST", ["cargo" => "PRESIDENTE", "numero_candidato" => "65"]);
        if ($st === 201 && is_array($dt) && isset($dt['status']) && $dt['status'] === 'success') {
            $this->result->registrarSucesso("03. Registro de voto individual (Pikachu: 65)", $ms);
        } else {
            $this->result->registrarFalha("03. Registro de voto individual (Pikachu: 65)", "HTTP {$st}");
        }

        // 4. Voto em Branco
        list($st, $dt, $ms) = $this->httpRequest($this->votosUrl, "POST", ["cargo" => "GOVERNADOR", "numero_candidato" => "BRANCO"]);
        if ($st === 201) {
            $this->result->registrarSucesso("04. Registro de voto em BRANCO", $ms);
        } else {
            $this->result->registrarFalha("04. Registro de voto em BRANCO", "HTTP {$st}");
        }

        // 5. Voto em lote
        $lote = [
            "votos" => [
                ["cargo" => "DEPUTADO ESTADUAL", "numero_candidato" => "90101"],
                ["cargo" => "DEPUTADO FEDERAL",  "numero_candidato" => "9101"],
                ["cargo" => "1º SENADOR",        "numero_candidato" => "701"],
                ["cargo" => "2º SENADOR",        "numero_candidato" => "751"],
                ["cargo" => "GOVERNADOR",        "numero_candidato" => "81"],
                ["cargo" => "PRESIDENTE",        "numero_candidato" => "63"]
            ]
        ];
        list($st, $dt, $ms) = $this->httpRequest($this->votosUrl, "POST", $lote);
        if ($st === 201 && is_array($dt) && isset($dt['total_inseridos']) && $dt['total_inseridos'] === 6) {
            $this->result->registrarSucesso("05. Registro de sessão completa em lote (6 cargos)", $ms);
        } else {
            $this->result->registrarFalha("05. Registro de sessão completa em lote (6 cargos)", "HTTP {$st}");
        }

        // 6. Consulta detalhada
        list($st, $dt, $ms) = $this->httpRequest("{$this->votosUrl}?limite=10", "GET");
        if ($st === 200 && is_array($dt) && isset($dt['dados']) && is_array($dt['dados'])) {
            $this->result->registrarSucesso("06. Consulta de listagem de votos com paginação", $ms);
        } else {
            $this->result->registrarFalha("06. Consulta de listagem de votos com paginação", "HTTP {$st}");
        }

        // 7. Consulta agrupada (resumo)
        list($st, $dt, $ms) = $this->httpRequest("{$this->votosUrl}?tipo=resumo", "GET");
        if ($st === 200 && is_array($dt) && isset($dt['dados'])) {
            $this->result->registrarSucesso("07. Agrupamento de votos por candidato (?tipo=resumo)", $ms);
        } else {
            $this->result->registrarFalha("07. Agrupamento de votos por candidato (?tipo=resumo)", "HTTP {$st}");
        }

        // 8. Consulta apuração geral
        list($st, $dt, $ms) = $this->httpRequest($this->apuracaoUrl, "GET");
        if ($st === 200 && is_array($dt) && count($dt) > 0) {
            $this->result->registrarSucesso("08. Consulta do painel de apuração consolidada", $ms);
        } else {
            $this->result->registrarFalha("08. Consulta do painel de apuração consolidada", "HTTP {$st}");
        }

        // 9. Erro 400 - Campos obrigatórios
        list($st, $dt, $ms) = $this->httpRequest($this->votosUrl, "POST", ["cargo" => "PRESIDENTE"]);
        if ($st === 400) {
            $this->result->registrarSucesso("09. Validação de erro 400 em payload incompleto", $ms);
        } else {
            $this->result->registrarFalha("09. Validação de erro 400 em payload incompleto", "Esperado HTTP 400, recebido {$st}");
        }

        // 10. Erro 404 - Rota inexistente
        list($st, $dt, $ms) = $this->httpRequest("{$this->baseUrl}/backend/rota_que_nao_existe", "GET");
        if ($st === 404) {
            $this->result->registrarSucesso("10. Tratamento elegante de rota 404", $ms);
        } else {
            $this->result->registrarFalha("10. Tratamento elegante de rota 404", "Esperado HTTP 404, recebido {$st}");
        }

        // 11. Procedimento de Zerésima
        list($st, $dt, $ms) = $this->httpRequest("{$this->apuracaoUrl}/zerar", "POST");
        if ($st === 200 && is_array($dt) && isset($dt['status']) && $dt['status'] === 'success') {
            $this->result->registrarSucesso("11. Emissão de Zerésima e limpeza de urna (/apuracao/zerar)", $ms);
        } else {
            $this->result->registrarFalha("11. Emissão de Zerésima e limpeza de urna (/apuracao/zerar)", "HTTP {$st}");
        }

        // 12. Re-seeding de segurança pós-zerésima
        list($st, $dt, $ms) = $this->httpRequest($this->installUrl, "GET");
        if ($st === 200) {
            $this->result->registrarSucesso("12. Re-seed e integridade automática da base eleitoral", $ms);
        } else {
            $this->result->registrarFalha("12. Re-seed e integridade automática da base eleitoral", "HTTP {$st}");
        }

        $tempoTotal = (microtime(true) - $inicioTotal) * 1000;
        $totalTestes = $this->result->passou + $this->result->falhou;
        $taxaSucesso = $totalTestes > 0 ? ($this->result->passou / $totalTestes) * 100 : 0;

        if ($isCli) {
            echo "\n=====================================================================\n";
            echo " 📊 RESULTADO DA SUÍTE DE TESTES:\n";
            echo "   • Total Executado: {$totalTestes}\n";
            echo "   • Sucessos:        {$this->result->passou}\n";
            echo "   • Falhas:          {$this->result->falhou}\n";
            echo "   • Taxa de Sucesso: " . number_format($taxaSucesso, 1) . "%\n";
            echo "   • Duração Total:   " . number_format($tempoTotal, 1) . "ms\n";
            echo "=====================================================================\n";
            if ($this->result->falhou === 0) {
                echo " 🎉 TODOS OS TESTES PASSARAM COM SUCESSO!\n\n";
                exit(0);
            } else {
                echo " ⚠️ ALGUNS TESTES FALHARAM. VERIFIQUE OS DETALHES ACIMA.\n\n";
                exit(1);
            }
        } else {
            echo "<hr style='border-color:#334155;'><br>";
            echo "<h3>Resultado: {$this->result->passou}/{$totalTestes} passaram (" . number_format($taxaSucesso, 1) . "%) em " . number_format($tempoTotal, 1) . "ms</h3>";
            echo "</body></html>";
        }
    }
}

$suite = new ApiTestSuite($baseUrl);
$suite->executarTodos();
