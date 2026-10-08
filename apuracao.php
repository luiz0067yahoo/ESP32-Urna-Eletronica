<?php
/**
 * ==============================================================================
 * URNA ELETRÔNICA POKÉMON • ATALHO DA APURAÇÃO EM TEMPO REAL
 * ==============================================================================
 * 
 * Permite acessar diretamente a tela de apuração eleitoral pela URL raiz:
 * Exemplo: http://seusite.com/apuracao.php
 */

header("Location: frontend/apuracao.html", true, 302);
exit();
