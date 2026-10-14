#!/usr/bin/perl
#

print "Incluyendo fichero: excel_mdl_course_modules_Insert\n";

sub excel_mdl_course_modules_Insert{
    my $Sub="excel_mdl_course_modules_Insert";
    my $excel_course_modules=shift;
    my $module=shift || 'quiz';
    iniSub($Sub);
    
    my $consulta="select id, instance, section, groupingid from $excel_course_modules order by section";  
    printT "$consulta\n"; 
    
    my $sth=$dbh_excel->prepare($consulta);
    $sth->execute();
    while (my ($id,$instance,$section,$grouping)=$sth->fetchrow_array()) {
	my $idInstance=mdl_quiz_Id($instance, $courseid, $module);
	my $groupingid=mdl_groupings_Id($grouping, $courseid)||"''";

	foreach my $idinstance (split(/,/, $idInstance)) {
	    #while(siono("id=$idinstance ($idInstance); pulsar s para continuar",'no','s') eq 'no') {};
	    #siosi("id=$idinstance ($idInstance); pulsar s para continuar",'no','s');
	    $id=mdl_course_modules_Insert($shortname,$section,$idinstance,$groupingid, $module);
	    mdl_course_sections_Update($shortname,$section,$id);
	}
    }
    finSub($Sub);
}
