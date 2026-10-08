<?php
/**
 * ==============================================================================
 * URNA ELETRÔNICA POKÉMON • ENTRADA PRINCIPAL
 * ==============================================================================
 * 
 * Este arquivo garante funcionamento imediato em qualquer hospedagem web
 * tradicional (cPanel, Apache, Nginx, LiteSpeed, Hostinger, Locaweb, XAMPP, etc.).
 * Ao acessar o domínio principal, o usuário é direcionado para a cabine de votação.
 */

// Redirecionamento 302 para a interface da Urna Eletrônica
header("Location: frontend/index.html", true, 302);
exit();
