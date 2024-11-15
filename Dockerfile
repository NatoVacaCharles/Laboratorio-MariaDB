# Usa una imagen base de Debian para instalar Apache, Perl y MariaDB
FROM debian:latest

# Instala Apache, Perl, MariaDB y módulos necesarios
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-perl2 perl mariadb-server \
    libdbi-perl libdbd-mysql-perl && \
    apt-get clean

# Habilita el módulo CGI de Apache
RUN a2enmod cgi

# Crea el directorio CGI y da permisos
RUN mkdir -p /usr/lib/cgi-bin
RUN chmod +x /usr/lib/cgi-bin

# Copia el script Perl en el directorio CGI
COPY cgi-bin/basedatos.pl /usr/lib/cgi-bin/basedatos.pl
RUN chmod +x /usr/lib/cgi-bin/basedatos.pl

# Copia el archivo de configuración de Apache
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Configuración de MariaDB: crear usuario y contraseña
RUN service mysql start && \
    mysql -e "CREATE USER 'renato'@'localhost' IDENTIFIED BY 'ponce';" && \
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'renato'@'localhost' WITH GRANT OPTION;" && \
    mysql -e "FLUSH PRIVILEGES;"

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar MariaDB y Apache
CMD ["sh", "-c", "service mysql start && apache2ctl -D FOREGROUND"]