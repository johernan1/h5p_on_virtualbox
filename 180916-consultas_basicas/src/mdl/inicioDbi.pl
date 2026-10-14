#!/usr/bin/perl
#

print "Incluyendo fichero: inicioDbi\n";
sub inicioDbi{
    
    use DBI;
    my $Sub="inicioDbi";
    my $dbname="moodle";
    # Usuario y password en maquina virtual windows
    #my $user="root";
    #my $password="platero";
    my $user="moodle";
    my $password="moodle";
    iniSub($Sub);
    
    printT "Se intenta establecer la conexión con $dbname\n";
    $dbh = DBI->connect("dbi:Pg:dbname=$dbname", $user, $password) ||
    #$dbh = DBI->connect("dbi:mysql:dbname=$dbname", $user, $password) ||
	die "inicioDBI:: No se ha podido  conectar con $dbname\n";  
    finSub($Sub);  
}


