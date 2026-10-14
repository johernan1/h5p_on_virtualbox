#!/usr/bin/perl
#

print "Incluyendo fichero: excel_mdl_groupings_groups_Insert\n";

sub excel_mdl_groupings_groups_Insert{
    my $excel_groupings_groups=shift;
    my $Sub="excel_groupings_groups_Insert";
    iniSub($Sub);


    my $consulta="select id, group, grouping from $excel_groupings_groups";  
    printT "$consulta\n"; 
    
    my $sth=$dbh_excel->prepare($consulta);
    $sth->execute();
    while (my ($id, $group, $grouping)=$sth->fetchrow_array()) {
	mdl_groups_Insert($group,$courseid);
	mdl_groupings_Insert($grouping,$courseid);
	mdl_groupings_groups_Insert($grouping,$group);
    }
    finSub($Sub);
}
