#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_course_sections_Update\n";

sub mdl_course_sections_Update{
    my $Sub="mdl_course_section_Update";
    my $sortname=shift;
    my $section=shift;
    my $module=shift;
    iniSub($Sub);
    my $course=mdl_course_Id($shortname);
    my $idsection=mdl_course_sections_Id($course, $section);

    my $consulta="select sequence from mdl_course_sections where section=$section and course=$course;";
    printT "$consulta\n"; 	
    
    ($sequence)=$dbh->selectrow_array($consulta);
    
    if ($sequence eq '') {
	$consulta="UPDATE mdl_course_sections SET sequence = '$module' where section=$section and course=$course;";  
	}
    else {
    	$consulta="UPDATE mdl_course_sections SET sequence = '$sequence,$module' where section=$section and course=$course;";  
   	}
    printT "$consulta\n";  	

    $dbh->do($consulta) || die "$consulta\n";
    
    finSub($Sub);
}
