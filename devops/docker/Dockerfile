FROM php:8.2-apache

# Habilita o módulo rewrite do Apache (necessário para o .htaccess)
RUN a2enmod rewrite

# Instala extensões necessárias do PHP (PDO MySQL)
RUN docker-php-ext-install pdo pdo_mysql

# Permite substituição de configuração via .htaccess no Apache
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Define o diretório de trabalho padrão do Apache
WORKDIR /var/www/html

# Copia o código do projeto para o container
COPY . /var/www/html/

# Copia o script de inicialização do entrypoint
COPY devops/docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Remove arquivos de infraestrutura da raiz web pública
RUN rm -rf /var/www/html/devops

# Ajusta permissões dos arquivos
RUN chown -R www-data:www-data /var/www/html

# Expõe a porta 80 do container
EXPOSE 80

# Define o entrypoint e o comando padrão
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
