#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_modules\n";

sub mdl_modules{
    my $Sub="mdl_modules";
    iniSub($Sub);

    my $consulta="select id, name from mdl_modules";  
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "id=$row[0], name=$row[1]\n";      
    }
    
    finSub($Sub);
}
