#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_course_Fullname\n";

sub mdl_course_Fullname{
    my $Sub="mdl_course_Fullname";
    my $shortname=shift;
    my $id, $fullname;
    iniSub($Sub);
    
    my $consulta="select fullname from mdl_course where shortname='$shortname'";
    printT "$consulta\n";
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    ($fullname)=$sth->fetchrow_array;
    if (!defined($fullname)) {die "No existe el curso '$shortname'";} 
    
    finSub($Sub);
    return $fullname;  
}
