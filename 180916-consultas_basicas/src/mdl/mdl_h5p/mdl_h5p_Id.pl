#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_h5p_Id\n";

sub mdl_h5p_Id{
    my $name=shift;
    my $course=shift;
    my $Sub="mdl_h5p_Id";
    iniSub($Sub);
    
    my $consulta="select id from mdl_h5pactivity where name='".$name."' and course='".$course."'";  
    printT "$consulta\n";  

    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    ($id)=$sth->fetchrow_array(); 
    if (!defined($id)) {die "No existe el cuestionario '$name' en el curso '$course'";}    
    
    finSub($Sub);
    return ($id);
}
