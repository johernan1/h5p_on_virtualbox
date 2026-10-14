#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_quiz_Id\n";

sub mdl_quiz_Id{
    my $name=shift;
    my $course=shift;
    my $module=shift || 'quiz'; # Esta funcion se ha 'ampliado'
                                # Debería llamarse mdl_MODULO_Id
    my $Sub="mdl_quiz_Id";
    iniSub($Sub);
    
    my $consulta="select id from mdl_$module where name='".$name."' and course='".$course."'";  
    printT "$consulta\n";

    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    ($id)=$sth->fetchrow_array();
    if (!defined($id)) {die "No existe el cuestionario '$name' en el curso '$course'";}
    my $idi;
    while ( ($idi)=$sth->fetchrow_array()) {
	$id="$id,$idi";
    }
    #if (!defined($idi)) {die "No existe el cuestionario '$name' en el curso '$course'";}   
#while(siono("id=$id; pulsar s para continuar",'no','s') eq 'no') {};    
    
    finSub($Sub);
    return ($id);
}
