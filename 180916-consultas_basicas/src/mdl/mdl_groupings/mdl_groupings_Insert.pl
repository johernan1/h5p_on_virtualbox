#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_groupings_Insert\n";

sub mdl_groupings_Insert{
    my $name=shift;
    my $courseid=shift;
    my $Sub="mdl_groupings_Insert";
    iniSub($Sub);
    
    $id=mdl_groupings_Id($name,$courseid);
    if (!defined($id)) {
	my $consulta="insert into mdl_groupings (name,courseid) VALUES ('$name',$courseid)";  
	printT "$consulta\n";  
	$dbh->do($consulta)||die "$consulta";
        $id=last_insert_Id("mdl_groupings");
    }

    finSub($Sub);
    return $id;
}
