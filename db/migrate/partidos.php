<?php
/**
 * Migração PHP Individual: Tabela 'partidos'
 */
require_once __DIR__ . '/../../backend/conecta.php';

$sqlPartidos = <<<SQL
CREATE TABLE IF NOT EXISTS `partidos` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `sigla` VARCHAR(20) NOT NULL UNIQUE COMMENT 'Sigla do partido (ex: POKPELE, POKPFGO)',
    `nome` VARCHAR(150) NOT NULL COMMENT 'Nome completo do partido',
    `slogan` VARCHAR(255) NULL COMMENT 'Slogan oficial da legenda',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
SQL;

if (basename(__FILE__) === basename($_SERVER['SCRIPT_FILENAME'] ?? $_SERVER['PHP_SELF'] ?? '')) {
    header('Content-Type: text/plain; charset=utf-8');
    echo "▶ Executando migração da tabela 'partidos'...\n";
    try {
        $db = Conexao::getConexao();
        if ($db) {
            $db->exec($sqlPartidos);
            echo "✔ Tabela 'partidos' criada/verificada com sucesso!\n";
        }
    } catch (Exception $e) {
        echo "❌ Erro ao criar tabela 'partidos': " . $e->getMessage() . "\n";
    }
}

return $sqlPartidos;
