<?php
/**
 * Migração do Banco de Dados - Urna Eletrônica Pokémon
 * Carrega e executa todas as migrações modulares da pasta db/migrate/
 */

require_once __DIR__ . '/../backend/conecta.php';

// Carrega todas as migrações individuais da pasta db/migrate/
$sqlMigrate = require __DIR__ . '/migrate/index.php';
