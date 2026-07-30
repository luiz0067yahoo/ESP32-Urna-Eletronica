<?php
/**
 * Classe Conexao
 * Gerencia a conexão com o banco de dados MySQL via PDO carregando variáveis de ambiente do arquivo .env.
 */
class Conexao {
    private $host;
    private $db_name;
    private $username;
    private $password;
    private $conn;

    public function __construct() {
        $this->carregarEnv(__DIR__ . '/.env');

        $this->host = getenv('DB_HOST');
        $this->username = getenv('DB_USER');
        $this->password = getenv('DB_PASS');
        $this->db_name = getenv('DB_NAME');
    }

    /**
     * Carrega variáveis a partir do arquivo .env se existir
     *
     * @param string $path Caminho para o arquivo .env
     */
    private function carregarEnv($path) {
        if (!file_exists($path)) {
            return;
        }

        $lines = file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            $line = trim($line);
            if (empty($line) || strpos($line, '#') === 0) {
                continue;
            }

            if (strpos($line, '=') !== false) {
                list($key, $val) = explode('=', $line, 2);
                $key = trim($key);
                $val = trim($val, " \t\n\r\0\x0B\"'");
                
                putenv("{$key}={$val}");
                $_ENV[$key] = $val;
                $_SERVER[$key] = $val;
            }
        }
    }

    /**
     * Retorna a conexão com o banco de dados.
     * 
     * @return PDO|null Instância de PDO ativa
     */
    public function conectar() {
        $this->conn = null;

        try {
            $this->conn = new PDO(
                "mysql:host=" . $this->host . ";dbname=" . $this->db_name . ";charset=utf8mb4",
                $this->username,
                $this->password,
                [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false
                ]
            );
        } catch (PDOException $exception) {
            header('Content-Type: application/json; charset=utf-8');
            http_response_code(500);
            echo json_encode([
                "status" => "error",
                "message" => "Erro na conexão com o banco de dados: " . $exception->getMessage()
            ], JSON_UNESCAPED_UNICODE);
            exit();
        }

        return $this->conn;
    }

    /**
     * Método estático facilitador para obter conexão.
     * 
     * @return PDO|null
     */
    public static function getConexao() {
        $instancia = new self();
        return $instancia->conectar();
    }
}
