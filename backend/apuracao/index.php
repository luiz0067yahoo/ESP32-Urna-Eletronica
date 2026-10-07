<?php
// Endpoint de Apuração Direto (Compatibilidade com servidores sem mod_rewrite)
$_GET['route'] = 'apuracao';
require_once __DIR__ . '/../index.php';
