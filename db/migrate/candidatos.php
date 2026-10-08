<?php
/**
 * Migração PHP Individual: Tabela 'candidatos'
 */
require_once __DIR__ . '/../../backend/conecta.php';

$sqlCandidatos = <<<SQL
CREATE TABLE IF NOT EXISTS `candidatos` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `numero` VARCHAR(20) NOT NULL UNIQUE COMMENT 'Número na urna',
    `nome` VARCHAR(100) NOT NULL COMMENT 'Nome do Pokémon candidato',
    `cargo` VARCHAR(100) NOT NULL COMMENT 'Cargo concorrido',
    `partido` VARCHAR(20) NOT NULL COMMENT 'Sigla do partido coligado',
    `foto` VARCHAR(255) NULL COMMENT 'URL da ilustração oficial PokeAPI',
    `vice` VARCHAR(100) NULL COMMENT 'Nome do vice / suplente',
    `foto_vice` VARCHAR(255) NULL COMMENT 'URL da foto do vice / suplente',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_cand_cargo` (`cargo`),
    INDEX `idx_cand_partido` (`partido`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
SQL;

if (basename(__FILE__) === basename($_SERVER['SCRIPT_FILENAME'] ?? $_SERVER['PHP_SELF'] ?? '')) {
    header('Content-Type: text/plain; charset=utf-8');
    echo "▶ Executando migração da tabela 'candidatos'...\n";
    try {
        $db = Conexao::getConexao();
        if ($db) {
            $db->exec($sqlCandidatos);
            echo "✔ Tabela 'candidatos' criada/verificada com sucesso!\n";
        }
    } catch (Exception $e) {
        echo "❌ Erro ao criar tabela 'candidatos': " . $e->getMessage() . "\n";
    }
}

return $sqlCandidatos;
