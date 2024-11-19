#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

# Creamos el cgi
my $q=CGI->new;
print $q->header('text/html; charset=UTF-8');

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
}) or die "<h1>Error al conectar a la base de datos: $DBI::errstr</h1>";

# Consulta del ejercicio
my $id = 5;
my $query = "SELECT * FROM actores WHERE actor_id = ?";
my $sth = $dbh->prepare($query);
$sth->execute($id);

# Ponemos los resultados en una variable para luego imprimirlos
my $resultados = "";
while (my @fila = $sth->fetchrow_array) {
    $resultados .= "<tr>\n";
    foreach my $dato (@fila) {
        $resultados .= "<td>$dato</td>\n";
    }
    $resultados .= "</tr>\n";
}

# Cerrar la conexión
$sth->finish();
$dbh->disconnect();

# Ejecutamos la página HTML
print <<'HTML';
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
            <a href="./cgi-bin/primer.pl" class="nav-link">Actor de ID 5</a>
            <a href="./cgi-bin/segundo.pl" class="nav-link">Actores con ID>=8</a>
            <a href="./cgi-bin/tercero.pl" class="nav-link">Películas con puntaje mayor a 7 y más de 5000 votos</a>
        </nav>
    </header>
    <main>
        <h3>Actor con ID igual a 5</h3>
        <table>
            <thead>
                <th>ID</th>
                <th>NOMBRE</th>
            </thead>
            <tbody>
HTML

print $resultados;

print <<'HTML';
            </tbody>
        </table>
        <a class="nav-link" href="index.html">Volver</a>
    </main>
    <footer>
        <p>Hecho por Renato Ponce. Todos los derechos reservados ©.</p>
    </footer>
</body>
</html>
HTML