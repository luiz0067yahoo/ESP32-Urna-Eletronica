<?php
/**
 * ==============================================================================
 * CONFIGURAÇÃO DO BANCO DE DADOS (HOSPEDAGEM TRADICIONAL PHP / MYSQL)
 * Urna Eletrônica Pokémon
 * ==============================================================================
 * 
 * Se sua hospedagem for cPanel, Hostinger, Locaweb, InfinityFree, Umbler,
 * KingHost ou XAMPP/WAMP, você pode salvar este arquivo como "config.php"
 * na pasta backend/ e preencher com os dados do seu banco.
 * 
 * Alternativamente, você também pode usar variáveis de ambiente ou o arquivo .env.
 */

// Host do servidor MySQL (Geralmente 'localhost' ou o IP/hostname do seu provedor)
define('DB_HOST', 'localhost');

// Nome do banco de dados criado no cPanel / phpMyAdmin
define('DB_NAME', 'urna');

// Usuário do banco de dados MySQL
define('DB_USER', 'root');

// Senha do usuário do banco de dados MySQL
define('DB_PASS', '');

// Porta do MySQL (o padrão costuma ser 3306)
define('DB_PORT', '3306');
