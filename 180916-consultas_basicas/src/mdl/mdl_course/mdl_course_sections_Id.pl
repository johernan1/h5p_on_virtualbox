#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_course_sections_Id\n";

sub mdl_course_sections_Id{
    my $Sub="mdl_course_sections_Id";
    my $course=shift;
    my $section=shift;
    iniSub($Sub);

    my $consulta="select id from mdl_course_sections where course=$course and section=$section";
    printT "$consulta\n"; 
 
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    ($id)=$sth->fetchrow_array(); 
    
    finSub($Sub);
    return $id
}
