#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

# Configuración de conexión con la base de datos
my $database = "prueba";
my $hostname = "mariadbc"; #nombre del contenedor
my $port     = 3307;
my $user     = "renato";
my $password = "ponce";

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

# Consulta del ejercicio
my $query = "SELECT * FROM actores WHERE actor_id=5";
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

# Ejecutamos la página html
my $q=CGI->new;
print $q->header('text-html; charset=UTF-8');
print<<'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="../estilos.css">
    <link rel="icon" type="image/png" href="../imagenes/logounsa.png">
    <title>Resultados</title>
</head>
<body>
    <header>
        <nav class="navegacion">
            <a href="/cgi-bin/primer.pl" class="nav-link">Actor de ID 5</a>
            <a href="/cgi-bin/segundo.pl" class="nav-link">Actores con ID>=8</a>
            <a href="/cgi-bin/tercero.pl" class="nav-link">Películas con puntaje mayor a 7 y más de 5000 votos</a>
        </nav>
    </header>
    <main>
        <h3>Actor con ID igual a 5</h3>
        <table>
            <thead>
                <th>Gaaa</th>
                <th>Gaaa</th>
                <th>Gaaa</th>
            </thead>
            <tr>
                <td>xd</td>
                <td>xd</td>
                <td>xd</td>
            </tr>
        </table>
        <a class="nav-link" href="index.html">Volver</a>
    </main>
    <footer>
        <p>Hecho por Renato Ponce. Todos los derechos reservados ©.</p>
    </footer>
</body>
</html>
HTML