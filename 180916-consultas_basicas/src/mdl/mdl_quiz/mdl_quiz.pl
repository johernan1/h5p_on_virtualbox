#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_quiz\n";

sub mdl_quiz{
    my $Sub="mdl_quiz";
    iniSub($Sub);

    my $consulta="select id, name, questions, sumgrades, grade from mdl_quiz";  
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "id=$row[0], name=$row[1], question=$row[2], sumgrade=$row[3], grade=$row[4]\n";      
    }
        
    finSub($Sub);
}
