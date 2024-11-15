#!/usr/bin/perl
use strict;
use warnings;
use DBI;

# Configuración de conexión
my $database = "prueba";
my $hostname = "mariadbc";         # Nombre del contenedor MariaDB
my $port     = 3307;               # Puerto predeterminado de MariaDB
my $user     = "renato";             # Usuario de MariaDB
my $password = "ponce"; # Contraseña para el usuario root

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $user, $password, {
    RaiseError       => 1,
    PrintError       => 0,
    mysql_enable_utf8 => 1,
});

if ($dbh) {
    print "Conexión exitosa a la base de datos '$database'.\n";
} else {
    die "Error al conectar a la base de datos: $DBI::errstr\n";
}

# Consulta de prueba
my $query = "SELECT * FROM peliculas";
my $sth = $dbh->prepare($query);
$sth->execute();

# Imprimir resultados de la consulta
while (my @row = $sth->fetchrow_array) {
    print join(", ", @row), "\n";
}

# Insertar un registro
my $sth = $dbh->prepare("INSERT INTO Actor( Name) VALUES (?)");
$sth->execute("Jhonny Deep");

# Cerrar la conexión
$sth->finish();
$dbh->disconnect();
