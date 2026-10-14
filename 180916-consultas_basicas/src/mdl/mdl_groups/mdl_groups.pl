#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_groups\n";

sub mdl_groups{
    my $Sub="mdl_groups";
    iniSub($Sub);

    my $consulta="select id, courseid, name from mdl_groups";  
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "id=$row[0], courseid=$row[1], name=$row[2]\n";
    }
    
    
    finSub($Sub);
}
