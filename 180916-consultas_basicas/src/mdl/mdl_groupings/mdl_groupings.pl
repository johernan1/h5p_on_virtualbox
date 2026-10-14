#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_groupings\n";

sub mdl_groupings{
    my $Sub="mdl_groupings";
    iniSub($Sub);

    my $consulta="select id, courseid, name from mdl_groupings";  
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "id=$row[0], courseid=$row[1], name=$row[2]\n";      
    }
    
    
    finSub($Sub);
}
