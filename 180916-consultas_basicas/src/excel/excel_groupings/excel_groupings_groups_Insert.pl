#!/usr/bin/perl
#

print "Incluyendo fichero: excel_groupings_groups_Insert\n";

sub excel_groupings_groups_Insert{
    my $excel_groupings_groups=shift;
    my $grouping=shift;
    my $group=shift;
    my $Sub="excel_groupings_groups_Insert";
    iniSub($Sub);
    
    

    my $consulta="select id from $excel_groupings_groups where grouping='$grouping' and group='$group'";
    printT "$consulta\n";  
    
    my $sth=$dbh_excel->prepare($consulta);
    $sth->execute();
    ($id)=$sth->fetchrow_array();# || die "No existe el grupo\n";
    if (!defined($id)) {
	my $id=excel_last_insert_Id($excel_groupings_groups);
	$id++;

	$consulta="insert into $excel_groupings_groups (id,grouping,group)
                  values ($id, '$grouping', '$group')";
	printT "$consulta\n";  
	$dbh_excel->do("$consulta") || die "$Sub: $consulta";
    }
    finSub($Sub);
}
