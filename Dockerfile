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

# Configura MariaDB manualmente
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld && \
    mysql_install_db --user=mysql --datadir=/var/lib/mysql && \
    mysqld_safe --skip-networking & \
    sleep 10 && \
    mysql -uroot -e "CREATE USER 'renato'@'%' IDENTIFIED BY 'ponce';" && \
    mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'renato'@'%' WITH GRANT OPTION;" && \
    mysqladmin shutdown

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar MariaDB y Apache
CMD ["sh", "-c", "mysqld_safe & apache2ctl -D FOREGROUND"]
