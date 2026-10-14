#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_h5p\n";

sub mdl_h5p{
    my $Sub="mdl_h5p";
    iniSub($Sub);

    my $consulta="select id, name, questions, sumgrades, grade from mdl_h5p";  
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "id=$row[0], name=$row[1], question=$row[2], sumgrade=$row[3], grade=$row[4]\n";      
    }
        
    finSub($Sub);
}
