# Usamos la última versión de debian
FROM debian:latest

# Instala Apache, Perl, MariaDB, Vim y módulos necesarios
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-perl2 perl mariadb-server \
    libdbi-perl libdbd-mysql-perl vim && \
    apt-get clean

# Habilita el módulo CGI de Apache
RUN a2enmod cgi

# Configura MariaDB manualmente
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld && \
    mysql_install_db --user=mysql --datadir=/var/lib/mysql && \
    mysqld_safe --skip-networking & \
    sleep 10 && \
    mysql -uroot -e "CREATE USER 'renato'@'%' IDENTIFIED BY 'ponce';" && \
    mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'renato'@'%' WITH GRANT OPTION;" && \
    mysqladmin shutdown

# Configura CGI y copia los scripts Perl
COPY cgi-bin/ /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/*.pl

# Copia todos los archivos del proyecto al directorio de Apache
COPY index.html /var/www/html/
COPY . /var/www/html/
RUN chmod -R 755 /var/www/html

# Copia el archivo de configuración de Apache
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar MariaDB y Apache
CMD ["sh", "-c", "mysqld_safe & apache2ctl -D FOREGROUND"]