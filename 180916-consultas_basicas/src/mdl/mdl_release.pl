#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_release\n";

sub mdl_release{

    $consulta=" select value from mdl_config where name='release'";
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    ($id)=$sth->fetchrow_array();       
 
    return($id);
}

sub is_mdl_release_ge{
    my ($r0, $r1, $r2) = split(/\./,mdl_release());
    my $r=shift;
    #Pausa("is_mdl_release_ge","r=$r","r0=$r0");
    if ($r0 ge $r) { return 1}
    return 0;
}

sub is_mdl_release_ge_or_die{
    my $r=shift;
    #Pausa("is_mdl_release_ge_die","$r");
    if (is_mdl_release_ge($r)) { return 1}
    die "mdl_release debe ser ge $r: \n";
}

sub is_mdl_release_eq{
    my ($r0, $r1, $r2) = split(/\./,mdl_release());
    if ($r0 eq shift) { return 1}
    return 0;
}

sub is_mdl_release_le{
    my ($r0, $r1, $r2) = split(/\./,mdl_release());
    if ($r0 le shift) { return 1}
    return 0;
}

sub is_mdl_release_le_or_die{
    my $r=shift;
    #Pausa("is_mdl_release_le_die","$r");
    if (is_mdl_release_le($r)) { return 1}
    die "mdl_release debe ser le $r: \n";
}
