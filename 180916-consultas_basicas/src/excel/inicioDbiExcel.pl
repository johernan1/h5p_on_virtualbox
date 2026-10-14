#!/usr/bin/perl
#

print "Incluyendo fichero: inicioDbiExcel\n";
sub inicioDbiExcel{
    
    use DBI;
    my $Sub="inicioDbiExcel";
    my $dbname=shift;
    iniSub($Sub);
    
    printT "Se intenta establecer la conexión con $dbname\n";
    #$dbh = DBI->connect("dbi:Pg:dbname=$dbname", $user, $password) ||
    $dbh_excel = DBI->connect("DBI:Excel:file=$dbname") ||
	die "$Sub:: No se ha podido  conectar con $dbname\n";  
    finSub($Sub);  
}


