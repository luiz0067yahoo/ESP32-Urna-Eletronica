<?php
/**
 * Migração PHP Individual: Tabela 'votos'
 */
require_once __DIR__ . '/../../backend/conecta.php';

$sqlVotos = <<<SQL
CREATE TABLE IF NOT EXISTS `votos` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `cargo` VARCHAR(100) NOT NULL COMMENT 'Cargo eletivo (ex: PRESIDENTE, GOVERNADOR, etc.)',
    `numero_candidato` VARCHAR(20) NOT NULL COMMENT 'Número digitado ou BRANCO / NULO',
    `data_voto` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Data e hora da computação do voto',
    INDEX `idx_cargo` (`cargo`),
    INDEX `idx_numero_candidato` (`numero_candidato`),
    INDEX `idx_cargo_numero` (`cargo`, `numero_candidato`),
    INDEX `idx_data_voto` (`data_voto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
SQL;

if (basename(__FILE__) === basename($_SERVER['SCRIPT_FILENAME'] ?? $_SERVER['PHP_SELF'] ?? '')) {
    header('Content-Type: text/plain; charset=utf-8');
    echo "▶ Executando migração da tabela 'votos'...\n";
    try {
        $db = Conexao::getConexao();
        if ($db) {
            $db->exec($sqlVotos);
            echo "✔ Tabela 'votos' criada/verificada com sucesso!\n";
        }
    } catch (Exception $e) {
        echo "❌ Erro ao criar tabela 'votos': " . $e->getMessage() . "\n";
    }
}

return $sqlVotos;
