#!/usr/bin/perl
#

print "Incluyendo fichero: excel_mdl_h5p_Insert\n";

sub excel_mdl_h5p_Insert {
    my $Sub="excel_mdl_h5p_Insert";
    $excel_question=shift;
    iniSub($Sub);

    my $consulta="select id, name, intro from $excel_quiz";  
    printT "$consulta\n"; 
    
    my $sth=$dbh_excel->prepare($consulta);
    $sth->execute();
    while (my ($id, $name, $intro)=$sth->fetchrow_array()) {
	$nvhp++;
	mdl_h5p_Insert("$name",$intro,$courseid);

    }
    finSub($Sub);
    return();
}

