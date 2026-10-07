<?php
// Endpoint de Votos Direto (Compatibilidade com servidores sem mod_rewrite)
$_GET['route'] = 'votos';
require_once __DIR__ . '/../index.php';
