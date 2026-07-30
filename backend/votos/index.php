<?php
// Configuração de cabeçalhos HTTP e CORS
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Trata requisição Preflight CORS
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once __DIR__ . '/../conecta.php';

// Conecta ao banco de dados
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
    // Silencia se a tabela já existir ou sem permissão de criação
}

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'POST':
        // Método POST: Criar novo voto
        
        // Obtém o corpo da requisição em formato JSON ou Form Data
        $inputRaw = file_get_contents("php://input");
        $data = json_decode($inputRaw, true);

        // Se não for JSON válido, tenta via $_POST
        if (!is_array($data)) {
            $data = $_POST;
        }

        // Obtém os parâmetros necessários (aceita 'cargo' e 'numero' ou 'numero_candidato')
        $cargo = isset($data['cargo']) ? trim($data['cargo']) : null;
        $numero_candidato = isset($data['numero_candidato']) ? trim($data['numero_candidato']) : (isset($data['numero']) ? trim($data['numero']) : null);

        // Validação básica dos dados recebidos
        if (empty($cargo) || empty($numero_candidato)) {
            http_response_code(400);
            echo json_encode([
                "status" => "error",
                "message" => "Parâmetros obrigatórios ausentes. Informe 'cargo' e 'numero_candidato' (ou 'numero')."
            ], JSON_UNESCAPED_UNICODE);
            exit();
        }

        try {
            $query = "INSERT INTO votos (cargo, numero_candidato) VALUES (:cargo, :numero_candidato)";
            $stmt = $db->prepare($query);
            $stmt->bindParam(':cargo', $cargo);
            $stmt->bindParam(':numero_candidato', $numero_candidato);

            if ($stmt->execute()) {
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
            } else {
                http_response_code(500);
                echo json_encode([
                    "status" => "error",
                    "message" => "Não foi possível registrar o voto."
                ], JSON_UNESCAPED_UNICODE);
            }
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode([
                "status" => "error",
                "message" => "Erro no servidor ao registrar voto: " . $e->getMessage()
            ], JSON_UNESCAPED_UNICODE);
        }
        break;

    case 'GET':
        // Método GET: Listar todos os votos dos candidatos por cargo
        
        $cargoFiltro = isset($_GET['cargo']) ? trim($_GET['cargo']) : null;
        $tipoListagem = isset($_GET['tipo']) ? trim($_GET['tipo']) : 'resumo';

        try {
            if ($tipoListagem === 'detalhado') {
                // Retorna todos os registros individuais de votos
                if ($cargoFiltro) {
                    $query = "SELECT id, cargo, numero_candidato, data_voto FROM votos WHERE cargo = :cargo ORDER BY data_voto DESC";
                    $stmt = $db->prepare($query);
                    $stmt->bindParam(':cargo', $cargoFiltro);
                } else {
                    $query = "SELECT id, cargo, numero_candidato, data_voto FROM votos ORDER BY data_voto DESC";
                    $stmt = $db->prepare($query);
                }
                $stmt->execute();
                $votos = $stmt->fetchAll();

                echo json_encode([
                    "status" => "success",
                    "total_registros" => count($votos),
                    "dados" => $votos
                ], JSON_UNESCAPED_UNICODE);
            } else {
                // Retorna a contagem/resumo de votos agrupados por cargo e candidato
                if ($cargoFiltro) {
                    $query = "SELECT cargo, numero_candidato, COUNT(*) AS total_votos 
                              FROM votos 
                              WHERE cargo = :cargo 
                              GROUP BY cargo, numero_candidato 
                              ORDER BY total_votos DESC";
                    $stmt = $db->prepare($query);
                    $stmt->bindParam(':cargo', $cargoFiltro);
                } else {
                    $query = "SELECT cargo, numero_candidato, COUNT(*) AS total_votos 
                              FROM votos 
                              GROUP BY cargo, numero_candidato 
                              ORDER BY cargo ASC, total_votos DESC";
                    $stmt = $db->prepare($query);
                }
                $stmt->execute();
                $resumo = $stmt->fetchAll();

                echo json_encode([
                    "status" => "success",
                    "total_grupos" => count($resumo),
                    "dados" => $resumo
                ], JSON_UNESCAPED_UNICODE);
            }
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode([
                "status" => "error",
                "message" => "Erro ao consultar votos: " . $e->getMessage()
            ], JSON_UNESCAPED_UNICODE);
        }
        break;

    default:
        http_response_code(405);
        echo json_encode([
            "status" => "error",
            "message" => "Método HTTP não permitido. Use GET ou POST."
        ], JSON_UNESCAPED_UNICODE);
        break;
}
