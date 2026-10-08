<?php 
/**
 * API RESTful da Urna Eletrônica • Roteador Central
 * Utiliza a classe Route (similar ao projeto de referência)
 */

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// ====================== CORS HEADERS ======================
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization");
header("Access-Control-Allow-Credentials: true");

// Trata requisições de preflight do navegador (OPTIONS)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit(0);
}
// ========================================================

require_once __DIR__ . '/route.php';
require_once __DIR__ . '/conecta.php';

// Conexão com o banco de dados via PDO
$conexaoObj = new Conexao();
$db = $conexaoObj->conectar();

// Garante que a tabela 'votos' existe
try {
    $sqlTabela = "CREATE TABLE IF NOT EXISTS votos (
        id INT AUTO_INCREMENT PRIMARY KEY,
        cargo VARCHAR(100) NOT NULL,
        numero_candidato VARCHAR(20) NOT NULL,
        data_voto DATETIME DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_cargo (cargo),
        INDEX idx_numero (numero_candidato)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";
    $db->exec($sqlTabela);
} catch (PDOException $e) {
    // Silencia se a tabela já existir ou sem permissão DDL
}

// Função auxiliar para capturar o corpo da requisição (JSON ou formulário)
function getRequestBody() {
    $inputRaw = file_get_contents("php://input");
    $data = json_decode($inputRaw, true);
    if (!is_array($data)) {
        $data = $_POST;
    }
    return is_array($data) ? $data : [];
}


//######################### VOTOS ####################################

// GET /votos - Lista todos os votos ou resumo agrupado
Route::add('/votos', function() use ($db) {
    header('Content-Type: application/json; charset=utf-8');
    $cargoFiltro = isset($_GET['cargo']) ? trim($_GET['cargo']) : null;
    $tipoListagem = isset($_GET['tipo']) ? trim($_GET['tipo']) : 'detalhado';
    $limite = isset($_GET['limite']) ? (int)$_GET['limite'] : 500;

    try {
        if ($tipoListagem === 'resumo' || isset($_GET['resumo'])) {
            $sql = "SELECT cargo, numero_candidato, COUNT(*) AS total_votos 
                    FROM votos " . 
                    ($cargoFiltro ? "WHERE cargo = :cargo " : "") . 
                    "GROUP BY cargo, numero_candidato 
                    ORDER BY cargo, total_votos DESC";
            $stmt = $db->prepare($sql);
            if ($cargoFiltro) {
                $stmt->execute([':cargo' => $cargoFiltro]);
            } else {
                $stmt->execute();
            }
            $dados = $stmt->fetchAll();
        } else {
            $sql = "SELECT id, cargo, numero_candidato, data_voto 
                    FROM votos " . 
                    ($cargoFiltro ? "WHERE cargo = :cargo " : "") . 
                    "ORDER BY id DESC LIMIT :limite";
            $stmt = $db->prepare($sql);
            if ($cargoFiltro) {
                $stmt->bindValue(':cargo', $cargoFiltro, PDO::PARAM_STR);
            }
            $stmt->bindValue(':limite', $limite, PDO::PARAM_INT);
            $stmt->execute();
            $dados = $stmt->fetchAll();
        }

        echo json_encode([
            "status" => "success",
            "total" => count($dados),
            "dados" => $dados
        ], JSON_UNESCAPED_UNICODE);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(["status" => "error", "message" => $e->getMessage()], JSON_UNESCAPED_UNICODE);
    }
}, 'get');

// GET /votos/{id} - Detalhes de um voto individual por ID
Route::add('/votos/([0-9]*)', function($id) use ($db) {
    header('Content-Type: application/json; charset=utf-8');
    try {
        $stmt = $db->prepare("SELECT id, cargo, numero_candidato, data_voto FROM votos WHERE id = :id");
        $stmt->execute([':id' => $id]);
        $voto = $stmt->fetch();
        if ($voto) {
            echo json_encode(["status" => "success", "dado" => $voto], JSON_UNESCAPED_UNICODE);
        } else {
            http_response_code(404);
            echo json_encode(["status" => "error", "message" => "Voto não encontrado."], JSON_UNESCAPED_UNICODE);
        }
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(["status" => "error", "message" => $e->getMessage()], JSON_UNESCAPED_UNICODE);
    }
}, 'get');

// POST /votos - Registra novo voto (individual ou lote de votos)
Route::add('/votos', function() use ($db) {
    header('Content-Type: application/json; charset=utf-8');
    $data = getRequestBody();

    $listaVotos = [];
    if (isset($data['votos']) && is_array($data['votos'])) {
        $listaVotos = $data['votos'];
    } elseif (isset($data[0]) && is_array($data[0])) {
        $listaVotos = $data;
    }

    if (!empty($listaVotos)) {
        try {
            $db->beginTransaction();
            $stmt = $db->prepare("INSERT INTO votos (cargo, numero_candidato) VALUES (:cargo, :numero_candidato)");
            $inseridos = 0;
            foreach ($listaVotos as $votoItem) {
                $c = isset($votoItem['cargo']) ? trim($votoItem['cargo']) : null;
                $n = isset($votoItem['numero_candidato']) ? trim($votoItem['numero_candidato']) : (isset($votoItem['numero']) ? trim($votoItem['numero']) : null);
                if (!empty($c) && !empty($n)) {
                    $stmt->execute([':cargo' => $c, ':numero_candidato' => $n]);
                    $inseridos++;
                }
            }
            $db->commit();
            http_response_code(201);
            echo json_encode([
                "status" => "success",
                "message" => "{$inseridos} voto(s) registrado(s) com sucesso!",
                "total_inseridos" => $inseridos
            ], JSON_UNESCAPED_UNICODE);
        } catch (PDOException $e) {
            if ($db->inTransaction()) {
                $db->rollBack();
            }
            http_response_code(500);
            echo json_encode(["status" => "error", "message" => "Erro ao registrar votos: " . $e->getMessage()], JSON_UNESCAPED_UNICODE);
        }
    } else {
        $cargo = isset($data['cargo']) ? trim($data['cargo']) : null;
        $numero_candidato = isset($data['numero_candidato']) ? trim($data['numero_candidato']) : (isset($data['numero']) ? trim($data['numero']) : null);

        if (empty($cargo) || empty($numero_candidato)) {
            http_response_code(400);
            echo json_encode([
                "status" => "error",
                "message" => "Parâmetros obrigatórios ausentes: 'cargo' e 'numero_candidato'."
            ], JSON_UNESCAPED_UNICODE);
            return;
        }

        try {
            $stmt = $db->prepare("INSERT INTO votos (cargo, numero_candidato) VALUES (:cargo, :numero_candidato)");
            $stmt->execute([':cargo' => $cargo, ':numero_candidato' => $numero_candidato]);
            http_response_code(201);
            echo json_encode([
                "status" => "success",
                "message" => "Voto registrado com sucesso!",
                "voto" => [
                    "id" => $db->lastInsertId(),
                    "cargo" => $cargo,
                    "numero_candidato" => $numero_candidato
                ]
            ], JSON_UNESCAPED_UNICODE);
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(["status" => "error", "message" => $e->getMessage()], JSON_UNESCAPED_UNICODE);
        }
    }
}, 'post');

// DELETE /votos/{id} - Remove voto individual por ID
Route::add('/votos/([0-9]*)', function($id) use ($db) {
    header('Content-Type: application/json; charset=utf-8');
    try {
        $stmt = $db->prepare("DELETE FROM votos WHERE id = :id");
        $stmt->execute([':id' => $id]);
        echo json_encode([
            "status" => "success",
            "message" => "Voto #{$id} removido com sucesso."
        ], JSON_UNESCAPED_UNICODE);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(["status" => "error", "message" => $e->getMessage()], JSON_UNESCAPED_UNICODE);
    }
}, 'delete');

// DELETE /votos - Zerésima (apaga todos os votos)
Route::add('/votos', function() use ($db) {
    header('Content-Type: application/json; charset=utf-8');
    try {
        try {
            $db->exec("TRUNCATE TABLE votos");
        } catch (PDOException $e) {
            $db->exec("DELETE FROM votos");
        }
        echo json_encode([
            "status" => "success",
            "message" => "Zerésima realizada com sucesso. Todos os votos foram zerados!"
        ], JSON_UNESCAPED_UNICODE);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(["status" => "error", "message" => $e->getMessage()], JSON_UNESCAPED_UNICODE);
    }
}, 'delete');


//######################### APURAÇÃO ####################################

// GET /apuracao - Retorna a apuração consolidada completa
Route::add('/apuracao', function() use ($db) {
    header('Content-Type: application/json; charset=utf-8');
    $cargoFiltro = isset($_GET['cargo']) ? trim($_GET['cargo']) : null;

    try {
        if ($cargoFiltro) {
            $stmtCargos = $db->prepare("SELECT DISTINCT cargo FROM votos WHERE cargo = :cargo ORDER BY cargo");
            $stmtCargos->execute([':cargo' => $cargoFiltro]);
        } else {
            $stmtCargos = $db->query("SELECT DISTINCT cargo FROM votos ORDER BY cargo");
        }
        $cargosEncontrados = $stmtCargos->fetchAll(PDO::FETCH_COLUMN);

        $cargosPadrao = ["PRESIDENTE", "GOVERNADOR", "1º SENADOR", "2º SENADOR", "DEPUTADO FEDERAL", "DEPUTADO ESTADUAL"];
        $cargosParaProcessar = array_unique(array_merge($cargosPadrao, $cargosEncontrados));
        if ($cargoFiltro) {
            $cargosParaProcessar = [$cargoFiltro];
        }

        $resultadoApuracao = [];
        $totalGeralVotos = 0;

        foreach ($cargosParaProcessar as $cargo) {
            $stmtTotal = $db->prepare("SELECT COUNT(*) AS total FROM votos WHERE cargo = :cargo");
            $stmtTotal->execute([':cargo' => $cargo]);
            $totalCargo = (int)$stmtTotal->fetchColumn();
            $totalGeralVotos += $totalCargo;

            $stmtBrancos = $db->prepare("SELECT COUNT(*) FROM votos WHERE cargo = :cargo AND UPPER(numero_candidato) = 'BRANCO'");
            $stmtBrancos->execute([':cargo' => $cargo]);
            $totalBrancos = (int)$stmtBrancos->fetchColumn();

            $stmtNulos = $db->prepare("SELECT COUNT(*) FROM votos WHERE cargo = :cargo AND UPPER(numero_candidato) = 'NULO'");
            $stmtNulos->execute([':cargo' => $cargo]);
            $totalNulos = (int)$stmtNulos->fetchColumn();

            $votosValidos = max(0, $totalCargo - $totalBrancos - $totalNulos);

            $stmtCand = $db->prepare("SELECT numero_candidato, COUNT(*) AS votos 
                                     FROM votos 
                                     WHERE cargo = :cargo 
                                       AND UPPER(numero_candidato) NOT IN ('BRANCO', 'NULO')
                                     GROUP BY numero_candidato 
                                     ORDER BY votos DESC");
            $stmtCand->execute([':cargo' => $cargo]);
            $candidatosVotos = $stmtCand->fetchAll();

            $ranking = [];
            foreach ($candidatosVotos as $c) {
                $qtdVotos = (int)$c['votos'];
                $pctTotal = $totalCargo > 0 ? round(($qtdVotos / $totalCargo) * 100, 2) : 0;
                $pctValidos = $votosValidos > 0 ? round(($qtdVotos / $votosValidos) * 100, 2) : 0;

                $ranking[] = [
                    "numero_candidato" => $c['numero_candidato'],
                    "votos" => $qtdVotos,
                    "percentual_total" => $pctTotal,
                    "percentual_validos" => $pctValidos
                ];
            }

            $pctBrancos = $totalCargo > 0 ? round(($totalBrancos / $totalCargo) * 100, 2) : 0;
            $pctNulos = $totalCargo > 0 ? round(($totalNulos / $totalCargo) * 100, 2) : 0;
            $pctValidos = $totalCargo > 0 ? round(($votosValidos / $totalCargo) * 100, 2) : 0;

            $resultadoApuracao[] = [
                "cargo" => $cargo,
                "total_votos" => $totalCargo,
                "votos_validos" => $votosValidos,
                "percentual_validos" => $pctValidos,
                "votos_brancos" => $totalBrancos,
                "percentual_brancos" => $pctBrancos,
                "votos_nulos" => $totalNulos,
                "percentual_nulos" => $pctNulos,
                "candidatos" => $ranking
            ];
        }

        echo json_encode([
            "status" => "success",
            "timestamp" => date("Y-m-d H:i:s"),
            "total_geral_votos" => $totalGeralVotos,
            "apuracao" => $resultadoApuracao
        ], JSON_UNESCAPED_UNICODE);

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(["status" => "error", "message" => "Erro na apuração: " . $e->getMessage()], JSON_UNESCAPED_UNICODE);
    }
}, 'get');

// POST /apuracao/zerar - Zerésima via rota apuração
Route::add('/apuracao/zerar', function() use ($db) {
    header('Content-Type: application/json; charset=utf-8');
    try {
        try {
            $db->exec("TRUNCATE TABLE votos");
        } catch (PDOException $e) {
            $db->exec("DELETE FROM votos");
        }
        echo json_encode([
            "status" => "success",
            "message" => "Zerésima da eleição realizada com sucesso!",
            "timestamp" => date("Y-m-d H:i:s")
        ], JSON_UNESCAPED_UNICODE);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(["status" => "error", "message" => $e->getMessage()], JSON_UNESCAPED_UNICODE);
    }
}, 'post');


//######################### ESTATÍSTICAS E STATUS ####################

// GET /estatisticas - Métricas e estatísticas gerais
Route::add('/estatisticas', function() use ($db) {
    header('Content-Type: application/json; charset=utf-8');
    try {
        $totalVotos = (int)$db->query("SELECT COUNT(*) FROM votos")->fetchColumn();
        $totalCargos = (int)$db->query("SELECT COUNT(DISTINCT cargo) FROM votos")->fetchColumn();
        $stmtCargos = $db->query("SELECT cargo, COUNT(*) AS votos FROM votos GROUP BY cargo ORDER BY votos DESC");
        $votosPorCargo = $stmtCargos->fetchAll();

        echo json_encode([
            "status" => "success",
            "estatisticas" => [
                "total_votos_computados" => $totalVotos,
                "cargos_com_votos" => $totalCargos,
                "distribuicao_por_cargo" => $votosPorCargo,
                "horario_servidor" => date("Y-m-d H:i:s")
            ]
        ], JSON_UNESCAPED_UNICODE);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(["status" => "error", "message" => $e->getMessage()], JSON_UNESCAPED_UNICODE);
    }
}, 'get');

// GET /status - Health check da API
Route::add('/status', function() use ($db) {
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        "status" => "online",
        "sistema" => "POKE Urna Eletrônica API",
        "banco_de_dados" => $db ? "conectado" : "desconectado",
        "timestamp" => date("Y-m-d H:i:s")
    ], JSON_UNESCAPED_UNICODE);
}, 'get');

// GET / - Rota raiz informativa
Route::add('/', function() {
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        "sistema" => "API RESTful - Urna Eletrônica Pokémon 2026",
        "versao" => "2.0.0",
        "rotas" => [
            "GET /votos" => "Lista todos os votos ou resumo",
            "GET /votos/{id}" => "Detalhe de um voto por ID",
            "POST /votos" => "Registra voto individual ou lote",
            "DELETE /votos" => "Zerésima (apaga todos os votos)",
            "DELETE /votos/{id}" => "Remove um voto por ID",
            "GET /apuracao" => "Apuração consolidada e percentuais por cargo",
            "POST /apuracao/zerar" => "Zera os votos para nova eleição",
            "GET /estatisticas" => "Métricas e estatísticas gerais",
            "GET /status" => "Status e conexão do servidor"
        ]
    ], JSON_UNESCAPED_UNICODE);
}, 'get');


// 404 - Rota não encontrada
Route::pathNotFound(function($path) {
    header('Content-Type: application/json; charset=utf-8');
    http_response_code(404);
    echo json_encode([
        "status" => "error",
        "message" => "Endpoint '{$path}' não encontrado.",
        "rotas_disponiveis" => [
            "GET /votos",
            "POST /votos",
            "DELETE /votos",
            "GET /apuracao",
            "POST /apuracao/zerar",
            "GET /estatisticas",
            "GET /status"
        ]
    ], JSON_UNESCAPED_UNICODE);
});

// 405 - Método não permitido
Route::methodNotAllowed(function($path, $method) {
    header('Content-Type: application/json; charset=utf-8');
    http_response_code(405);
    echo json_encode([
        "status" => "error",
        "message" => "Método {$method} não permitido para o endpoint '{$path}'."
    ], JSON_UNESCAPED_UNICODE);
});


// ========================================================
// EXECUÇÃO DO ROTEADOR COM DETERMINAÇÃO DE BASEPATH
// ========================================================

// Suporte direto para chamadas via ?route=... (como em backend/apuracao/index.php)
if (isset($_GET['route'])) {
    $_SERVER['REQUEST_URI'] = '/' . ltrim($_GET['route'], '/');
    $basepath = '';
} else {
    // Detecta automaticamente o caminho base do backend na URL requisitada
    $uriPath = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
    $pos = strpos($uriPath, '/backend');
    if ($pos !== false) {
        $basepath = substr($uriPath, 0, $pos + strlen('/backend'));
    } else {
        $scriptDir = str_replace('\\', '/', dirname($_SERVER['SCRIPT_NAME']));
        $basepath = ($scriptDir === '/' || $scriptDir === '.') ? '' : $scriptDir;
    }
}

Route::run($basepath);
