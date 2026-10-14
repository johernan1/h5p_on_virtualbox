#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_groupings_groups_Insert\n";

sub mdl_groupings_groups_Insert{
    my $grouping=shift;
    my $group=shift;
    my $Sub="mdl_groupings_groups_Insert";
    iniSub($Sub);
    
    
    $groupingid=mdl_groupings_Id($grouping,$courseid);
    $groupid=mdl_groups_Id($group,$courseid);
    

    my $consulta="select id from mdl_groupings_groups where groupingid=$groupingid and groupid=$groupid";
    printT "$consulta\n";  
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    ($id)=$sth->fetchrow_array();# || die "No existe el grupo\n";
    if (!defined($id)) {
	$consulta="insert into mdl_groupings_groups (groupingid,groupid)
                  values ($groupingid, $groupid)";
	printT "$consulta\n";  
	$dbh->do("$consulta") || die "$Sub: $consulta";
    }
    finSub($Sub);
}
