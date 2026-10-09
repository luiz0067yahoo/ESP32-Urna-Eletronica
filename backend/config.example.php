<?php
/**
 * ==============================================================================
 * CONFIGURAÇÃO DO BANCO DE DADOS (HOSPEDAGEM TRADICIONAL PHP / MYSQL)
 * Urna Eletrônica Pokémon
 * ==============================================================================
 * 
 * Se sua hospedagem for cPanel, Hostinger, Locaweb, InfinityFree, Umbler,
 * KingHost ou XAMPP/WAMP, você pode salvar este arquivo como "config.php"
 * na pasta backend/.
 * 
 * Este arquivo carrega automaticamente os dados de /.env, /backend/.env,
 * /.env.example ou /backend/.env.example caso existam.
 */

// Função auxiliar para carregar .env ou .env.example
if (!function_exists('carregarEnvConfig')) {
    function carregarEnvConfig($caminhos) {
        foreach ($caminhos as $caminho) {
            if (file_exists($caminho) && is_readable($caminho)) {
                $linhas = file($caminho, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
                if ($linhas !== false) {
                    foreach ($linhas as $linha) {
                        $linha = trim($linha);
                        if (empty($linha) || strpos($linha, '#') === 0 || strpos($linha, ';') === 0) {
                            continue;
                        }
                        if (strpos($linha, '=') !== false) {
                            list($chave, $valor) = explode('=', $linha, 2);
                            $chave = trim($chave);
                            $valor = trim($valor, " \t\n\r\0\x0B\"'");
                            if (getenv($chave) === false || getenv($chave) === '') {
                                putenv("{$chave}={$valor}");
                                $_ENV[$chave] = $valor;
                                $_SERVER[$chave] = $valor;
                            }
                        }
                    }
                    return true;
                }
            }
        }
        return false;
    }
}

// Procura por .env ou .env.example centralizados na raiz do projeto
$raizDir = dirname(__DIR__);
carregarEnvConfig([
    $raizDir . '/.env',
    $raizDir . '/.env.example',
    __DIR__ . '/.env'
]);

// Host do servidor MySQL (Geralmente 'localhost' ou o IP/hostname do seu provedor)
if (!defined('DB_HOST')) {
    define('DB_HOST', getenv('DB_HOST') ?: 'localhost');
}

// Porta do MySQL (o padrão costuma ser 3306)
if (!defined('DB_PORT')) {
    define('DB_PORT', getenv('DB_PORT') ?: '3306');
}

// Nome do banco de dados
if (!defined('DB_NAME')) {
    define('DB_NAME', getenv('DB_NAME') ?: 'urna');
}

// Usuário do banco de dados MySQL
if (!defined('DB_USER')) {
    define('DB_USER', getenv('DB_USER') ?: 'root');
}

// Senha do usuário do banco de dados MySQL
if (!defined('DB_PASS')) {
    define('DB_PASS', getenv('DB_PASS') !== false ? getenv('DB_PASS') : '');
}
