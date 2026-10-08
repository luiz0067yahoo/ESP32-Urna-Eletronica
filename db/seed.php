<?php
/**
 * Seed (Povoamento) do Banco de Dados - Urna Eletrônica Pokémon
 * Carrega e executa todos os seeds modulares da pasta db/seed/
 */

require_once __DIR__ . '/../backend/conecta.php';

// Carrega todos os seeds individuais da pasta db/seed/
$sqlSeed = require __DIR__ . '/seed/index.php';
