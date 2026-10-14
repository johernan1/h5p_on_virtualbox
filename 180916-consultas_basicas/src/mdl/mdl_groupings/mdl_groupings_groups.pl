#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_groupings_groups\n";

sub mdl_groupings_groups{
    my $Sub="mdl_groupings_groups";
    iniSub($Sub);

    my $consulta="select id, groupid, groupingid from mdl_groupings_groups";  
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "id=$row[0], groupid=$row[1], groupingid=$row[2]\n";
    }
    
    
    finSub($Sub);
}
