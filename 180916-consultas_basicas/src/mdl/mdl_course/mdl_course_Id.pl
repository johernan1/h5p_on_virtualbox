#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_course_Id\n";

sub mdl_course_Id{
    my $Sub="mdl_course_Id";
    my $shortname=shift;
    my $id, $fullname;
    iniSub($Sub);
    
    my $consulta="select id from mdl_course where shortname='$shortname'";
    printT "$consulta\n";
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    ($id)=$sth->fetchrow_array;
    if (!defined($id)) {die "No existe el curso '$shortname'";}
    
    finSub($Sub);
    return $id;  
}
