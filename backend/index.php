<?php
/**
 * API RESTful da Urna Eletrônica
 * Rotas e Controladores para Votos, Apuração e Estatísticas
 */

// Cabeçalhos HTTP e CORS
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Resposta a requisições Preflight (OPTIONS)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once __DIR__ . '/conecta.php';

// Conexão com o banco de dados
$conexaoObj = new Conexao();
$db = $conexaoObj->conectar();

// Garante que a tabela 'votos' existe
try {
    $sqlTabela = "CREATE TABLE IF NOT EXISTS votos (
        id INT AUTO_INCREMENT PRIMARY KEY,
        cargo VARCHAR(50) NOT NULL,
        numero_candidato VARCHAR(20) NOT NULL,
        data_voto DATETIME DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";
    $db->exec($sqlTabela);
} catch (PDOException $e) {
    // Silencia se já existir
}

// Resolução da Rota RESTful
$method = $_SERVER['REQUEST_METHOD'];

// Extrai o caminho da requisição após o diretório 'backend'
$requestUri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$pos = strpos($requestUri, '/backend');
if ($pos !== false) {
    $path = substr($requestUri, $pos + strlen('/backend'));
} else {
    $path = $requestUri;
}
$path = trim($path, '/');

// Suporte alternativo via query param ?route=...
if (isset($_GET['route'])) {
    $path = trim($_GET['route'], '/');
}

// Remove extensão .php se chamada diretamente (ex: index.php/votos -> votos)
$path = preg_replace('/^index\.php\/?/', '', $path);
$segments = $path === '' ? [] : explode('/', $path);
$resource = isset($segments[0]) ? strtolower($segments[0]) : '';
$resourceId = isset($segments[1]) ? $segments[1] : null;

// Função auxiliar para ler JSON do corpo da requisição
function getRequestBody() {
    $inputRaw = file_get_contents("php://input");
    $data = json_decode($inputRaw, true);
    if (!is_array($data)) {
        $data = $_POST;
    }
    return is_array($data) ? $data : [];
}

// Roteador RESTful
switch ($resource) {

    // =========================================================================
    // ROTA: /votos
    // =========================================================================
    case 'votos':
        if ($method === 'GET') {
            if ($resourceId !== null && is_numeric($resourceId)) {
                // GET /votos/{id} - Detalhe de voto por ID
                try {
                    $stmt = $db->prepare("SELECT id, cargo, numero_candidato, data_voto FROM votos WHERE id = :id");
                    $stmt->execute([':id' => $resourceId]);
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
            } else {
                // GET /votos - Lista todos os votos com filtros opcionais
                $cargoFiltro = isset($_GET['cargo']) ? trim($_GET['cargo']) : null;
                $tipoListagem = isset($_GET['tipo']) ? trim($_GET['tipo']) : 'detalhado';
                $limite = isset($_GET['limite']) ? (int)$_GET['limite'] : 500;

                try {
                    if ($tipoListagem === 'resumo') {
                        // Votos agrupados por cargo e candidato
                        if ($cargoFiltro) {
                            $stmt = $db->prepare("SELECT cargo, numero_candidato, COUNT(*) AS total_votos 
                                                  FROM votos 
                                                  WHERE cargo = :cargo 
                                                  GROUP BY cargo, numero_candidato 
                                                  ORDER BY total_votos DESC");
                            $stmt->execute([':cargo' => $cargoFiltro]);
                        } else {
                            $stmt = $db->prepare("SELECT cargo, numero_candidato, COUNT(*) AS total_votos 
                                                  FROM votos 
                                                  GROUP BY cargo, numero_candidato 
                                                  ORDER BY cargo ASC, total_votos DESC");
                            $stmt->execute();
                        }
                        $dados = $stmt->fetchAll();
                    } else {
                        // Lista individual detalhada
                        if ($cargoFiltro) {
                            $stmt = $db->prepare("SELECT id, cargo, numero_candidato, data_voto 
                                                  FROM votos 
                                                  WHERE cargo = :cargo 
                                                  ORDER BY id DESC LIMIT :limite");
                            $stmt->bindValue(':cargo', $cargoFiltro, PDO::PARAM_STR);
                            $stmt->bindValue(':limite', $limite, PDO::PARAM_INT);
                            $stmt->execute();
                        } else {
                            $stmt = $db->prepare("SELECT id, cargo, numero_candidato, data_voto 
                                                  FROM votos 
                                                  ORDER BY id DESC LIMIT :limite");
                            $stmt->bindValue(':limite', $limite, PDO::PARAM_INT);
                            $stmt->execute();
                        }
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
            }
        } elseif ($method === 'POST') {
            // POST /votos - Registra novo voto ou lista de votos (batch)
            $data = getRequestBody();

            // Detecta envio de lista/lote de votos
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
                // Voto único individual
                $cargo = isset($data['cargo']) ? trim($data['cargo']) : null;
                $numero_candidato = isset($data['numero_candidato']) ? trim($data['numero_candidato']) : (isset($data['numero']) ? trim($data['numero']) : null);

                if (empty($cargo) || empty($numero_candidato)) {
                    http_response_code(400);
                    echo json_encode([
                        "status" => "error",
                        "message" => "Parâmetros obrigatórios ausentes: 'cargo' e 'numero_candidato' (ou 'numero')."
                    ], JSON_UNESCAPED_UNICODE);
                    exit();
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
        } elseif ($method === 'DELETE') {
            if ($resourceId !== null && is_numeric($resourceId)) {
                // DELETE /votos/{id} - Remove voto individual
                try {
                    $stmt = $db->prepare("DELETE FROM votos WHERE id = :id");
                    $stmt->execute([':id' => $resourceId]);
                    echo json_encode([
                        "status" => "success",
                        "message" => "Voto #{$resourceId} removido com sucesso."
                    ], JSON_UNESCAPED_UNICODE);
                } catch (PDOException $e) {
                    http_response_code(500);
                    echo json_encode(["status" => "error", "message" => $e->getMessage()], JSON_UNESCAPED_UNICODE);
                }
            } else {
                // DELETE /votos - Zerésima (limpa todos os votos)
                try {
                    $db->exec("TRUNCATE TABLE votos");
                    echo json_encode([
                        "status" => "success",
                        "message" => "Zerésima realizada com sucesso. Todos os votos foram zerados!"
                    ], JSON_UNESCAPED_UNICODE);
                } catch (PDOException $e) {
                    // Fallback para DELETE caso TRUNCATE falhe
                    $db->exec("DELETE FROM votos");
                    echo json_encode([
                        "status" => "success",
                        "message" => "Zerésima realizada com sucesso. Todos os votos foram apagados!"
                    ], JSON_UNESCAPED_UNICODE);
                }
            }
        } else {
            http_response_code(405);
            echo json_encode(["status" => "error", "message" => "Método não permitido para /votos."], JSON_UNESCAPED_UNICODE);
        }
        break;

    // =========================================================================
    // ROTA: /apuracao
    // =========================================================================
    case 'apuracao':
        if ($method === 'GET') {
            // GET /apuracao - Retorna a apuração consolidada completa
            $cargoFiltro = isset($_GET['cargo']) ? trim($_GET['cargo']) : null;

            try {
                // 1. Obtém a lista de cargos votados ou o cargo selecionado
                if ($cargoFiltro) {
                    $stmtCargos = $db->prepare("SELECT DISTINCT cargo FROM votos WHERE cargo = :cargo ORDER BY cargo");
                    $stmtCargos->execute([':cargo' => $cargoFiltro]);
                } else {
                    $stmtCargos = $db->query("SELECT DISTINCT cargo FROM votos ORDER BY cargo");
                }
                $cargosEncontrados = $stmtCargos->fetchAll(PDO::FETCH_COLUMN);

                // Garante que mesmo sem votos os cargos padrões estejam presentes se solicitado
                $cargosPadrao = ["DEPUTADO FEDERAL", "DEPUTADO ESTADUAL", "1º SENADOR", "2º SENADOR", "GOVERNADOR", "PRESIDENTE"];
                $cargosParaProcessar = array_unique(array_merge($cargosPadrao, $cargosEncontrados));
                if ($cargoFiltro) {
                    $cargosParaProcessar = [$cargoFiltro];
                }

                $resultadoApuracao = [];
                $totalGeralVotos = 0;

                foreach ($cargosParaProcessar as $cargo) {
                    // Contagem total por cargo
                    $stmtTotal = $db->prepare("SELECT COUNT(*) AS total FROM votos WHERE cargo = :cargo");
                    $stmtTotal->execute([':cargo' => $cargo]);
                    $totalCargo = (int)$stmtTotal->fetchColumn();
                    $totalGeralVotos += $totalCargo;

                    // Contagem de brancos
                    $stmtBrancos = $db->prepare("SELECT COUNT(*) FROM votos WHERE cargo = :cargo AND UPPER(numero_candidato) = 'BRANCO'");
                    $stmtBrancos->execute([':cargo' => $cargo]);
                    $totalBrancos = (int)$stmtBrancos->fetchColumn();

                    // Contagem de nulos
                    $stmtNulos = $db->prepare("SELECT COUNT(*) FROM votos WHERE cargo = :cargo AND UPPER(numero_candidato) = 'NULO'");
                    $stmtNulos->execute([':cargo' => $cargo]);
                    $totalNulos = (int)$stmtNulos->fetchColumn();

                    // Votos válidos = total - brancos - nulos
                    $votosValidos = max(0, $totalCargo - $totalBrancos - $totalNulos);

                    // Agrupamento de votos por candidato (exclui brancos e nulos literais)
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
        } elseif ($method === 'POST' || $method === 'DELETE') {
            // POST /apuracao/zerar ou DELETE /apuracao - Zerésima
            if ($resourceId === 'zerar' || $method === 'DELETE' || $method === 'POST') {
                try {
                    $db->exec("DELETE FROM votos");
                    echo json_encode([
                        "status" => "success",
                        "message" => "Zerésima concluída. Todos os votos foram zerados com sucesso!",
                        "timestamp" => date("Y-m-d H:i:s")
                    ], JSON_UNESCAPED_UNICODE);
                } catch (PDOException $e) {
                    http_response_code(500);
                    echo json_encode(["status" => "error", "message" => "Erro ao zerar apuração: " . $e->getMessage()], JSON_UNESCAPED_UNICODE);
                }
            } else {
                http_response_code(400);
                echo json_encode(["status" => "error", "message" => "Ação de apuração não reconhecida."], JSON_UNESCAPED_UNICODE);
            }
        } else {
            http_response_code(405);
            echo json_encode(["status" => "error", "message" => "Método não permitido para /apuracao."], JSON_UNESCAPED_UNICODE);
        }
        break;

    // =========================================================================
    // ROTA: /estatisticas
    // =========================================================================
    case 'estatisticas':
        if ($method === 'GET') {
            try {
                $totalVotos = (int)$db->query("SELECT COUNT(*) FROM votos")->fetchColumn();
                $primeiroVoto = $db->query("SELECT MIN(data_voto) FROM votos")->fetchColumn();
                $ultimoVoto = $db->query("SELECT MAX(data_voto) FROM votos")->fetchColumn();

                $stmtPorCargo = $db->query("SELECT cargo, COUNT(*) AS total FROM votos GROUP BY cargo ORDER BY total DESC");
                $votosPorCargo = $stmtPorCargo->fetchAll();

                echo json_encode([
                    "status" => "success",
                    "total_votos" => $totalVotos,
                    "primeiro_voto" => $primeiroVoto,
                    "ultimo_voto" => $ultimoVoto,
                    "votos_por_cargo" => $votosPorCargo
                ], JSON_UNESCAPED_UNICODE);
            } catch (PDOException $e) {
                http_response_code(500);
                echo json_encode(["status" => "error", "message" => $e->getMessage()], JSON_UNESCAPED_UNICODE);
            }
        } else {
            http_response_code(405);
            echo json_encode(["status" => "error", "message" => "Método não permitido para /estatisticas."], JSON_UNESCAPED_UNICODE);
        }
        break;

    // =========================================================================
    // ROTA RAIZ DA API: / ou /api
    // =========================================================================
    case '':
    case 'api':
        echo json_encode([
            "nome" => "API RESTful - Urna Eletrônica",
            "versao" => "2.0.0",
            "status" => "operacional",
            "rotas_disponiveis" => [
                "GET /backend/votos" => "Lista todos os votos (filtros: ?cargo=..., ?tipo=detalhado|resumo, ?limite=...)",
                "GET /backend/votos/{id}" => "Detalhe de um voto por ID",
                "POST /backend/votos" => "Registra voto individual ou lista de votos em lote { votos: [...] }",
                "DELETE /backend/votos/{id}" => "Remove um voto individual",
                "DELETE /backend/votos" => "Zerésima da Urna (limpa todos os votos)",
                "GET /backend/apuracao" => "Apuração completa e percentuais de votos por cargo",
                "POST /backend/apuracao/zerar" => "Zera os votos para novo treinamento/eleição",
                "GET /backend/estatisticas" => "Métricas e estatísticas gerais dos votos"
            ]
        ], JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
        break;

    default:
        http_response_code(404);
        echo json_encode([
            "status" => "error",
            "message" => "Rota '{$resource}' não encontrada na API.",
            "rotas_sugeridas" => ["/backend/votos", "/backend/apuracao", "/backend/estatisticas"]
        ], JSON_UNESCAPED_UNICODE);
        break;
}
