#!/usr/bin/env bash
set -e

echo "=========================================================="
echo "  🗳️ URNA ELETRÔNICA POKÉMON - PODMAN ENTRYPOINT"
echo "=========================================================="

DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-3306}"
DB_USER="${DB_USER:-urna}"
DB_PASS="${DB_PASS:-urna123}"
DB_NAME="${DB_NAME:-urna}"

echo "1. Aguardando banco de dados em ${DB_HOST}:${DB_PORT}..."

MAX_TRIES=30
COUNT=0
until php -r "
try {
    \$dbh = new PDO('mysql:host=${DB_HOST};port=${DB_PORT};dbname=${DB_NAME}', '${DB_USER}', '${DB_PASS}');
    exit(0);
} catch (Exception \$e) {
    exit(1);
}
" >/dev/null 2>&1; do
    COUNT=$((COUNT + 1))
    if [ $COUNT -ge $MAX_TRIES ]; then
        echo "⚠️ Aviso: Banco de dados não respondeu após $MAX_TRIES tentativas. Continuando inicialização..."
        break
    fi
    echo "   -> Aguardando inicialização do banco ($COUNT/$MAX_TRIES)..."
    sleep 2
done

if [ $COUNT -lt $MAX_TRIES ]; then
    echo "✔ Conexão com o banco de dados estabelecida com sucesso!"
    echo "2. Executando migração e seed (db/install.php)..."
    php /var/www/html/db/install.php || true
fi

echo "3. Iniciando servidor web..."
echo "=========================================================="

exec "$@"
