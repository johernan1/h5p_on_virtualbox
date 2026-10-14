#!/usr/bin/perl
#

print "Incluyendo fichero: last_insert_Id\n";

sub last_insert_Id {
    my $tabla = shift;
    my $driver_name = $dbh->{Driver}{Name}; # Retorna 'mysql', 'Pg', etc.
    my $id;

    if ($driver_name eq 'mysql') {
        # Sintaxis nativa para MySQL
        $consulta = "SELECT LAST_INSERT_ID()";
        my $sth = $dbh->prepare($consulta);
        $sth->execute();
        ($id) = $sth->fetchrow_array();
    } 
    elsif ($driver_name eq 'Pg') {
        # Sintaxis nativa para PostgreSQL
        $consulta = "SELECT last_value FROM " . $tabla . "_id_seq";
        printT "\nSe prueba $consulta\n\n" if defined &printT;
        my $sth = $dbh->prepare($consulta);
        $sth->execute() || die "$consulta: " . $dbh->errstr;
        ($id) = $sth->fetchrow_array();
    } 
    else {
        # Método estándar alternativo DBI (funciona en la mayoría de drivers si la tabla define un autoincremento)
        $id = $dbh->last_insert_id(undef, undef, $tabla, undef);
    }

    return $id;
}

sub last_insert_Id_KO{

    my $tabla=shift;

# comentado 210105 ¿¿¿???    pg_errorlevel (integer);
    $consulta="select LAST_INSERT_ID()";
    my $sth=$dbh->prepare($consulta);
#    eval { #mysql
#	$sth->execute(); # mysql
#	1;
#    }
#    or do { #postgresql
#	$consulta="select last_value from ".$tabla."_id_seq";
#	printT "\nSe prueba $consulta\n\n";
#	$sth=$dbh->prepare($consulta);
#	$sth->execute() || die "$consulta";
#    };   
    if ($sth->execute()) { # mysql
    }
    else { #postgresql
	$consulta="select last_value from ".$tabla."_id_seq";
	printT "\nSe prueba $consulta\n\n";
	$sth=$dbh->prepare($consulta);
	$sth->execute() || die "$consulta";
    }
    ($id)=$sth->fetchrow_array();
 
    return($id);
}
