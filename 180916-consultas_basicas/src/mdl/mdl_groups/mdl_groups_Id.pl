#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_groups_Id\n";

sub mdl_groups_Id{
    my $name=shift;
    my $courseid=shift;
    my $Sub="mdl_groups_Id";
    iniSub($Sub);
    
    my $consulta="select id from mdl_groups where name='$name' and courseid=$courseid";  
    printT "$consulta\n";  
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    ($id)=$sth->fetchrow_array();# || die "No existe el grupo\n";
    
    finSub($Sub);
    return $id;
}


