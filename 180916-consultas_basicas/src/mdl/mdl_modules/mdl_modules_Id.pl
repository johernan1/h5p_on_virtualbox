#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_modules_Id\n";

sub mdl_modules_Id{
    my $Sub="mdl_modules_Id";
    my $name=shift;
    my $id;
    iniSub($Sub);
    
    my $consulta="select id from mdl_modules where name='$name'";
    printT "$consulta\n";
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    ($id)=$sth->fetchrow_array;
    if (!defined($id)) {die "No existe el modulo '$name'";} 
    
    finSub($Sub);
    return $id;  
}
