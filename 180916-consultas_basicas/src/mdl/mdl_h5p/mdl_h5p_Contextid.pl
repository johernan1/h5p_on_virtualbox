#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_h5p_Contextid\n";

sub mdl_h5p_Contextid{
    my $name=shift;
    my $Sub="mdl_h5p_Contextid";
    iniSub($Sub);
    
    #my $consulta="select id from mdl_course_modules where instance='$name'";  
    #printT "$consulta\n"; 
    #my $sth=$dbh->prepare($consulta);
    #$sth->execute();
    #($contextid)=$sth->fetchrow_array() || 
#	die {Pausa("Tenemos un problema con el nombre '$name' el hp5")};
   # 
    #while(siono("contextid=$contextid; pulsar y para continuar",'si','no') eq 'si') {};#
    $contextid=last_insert_Id("mdl_context");
    $contextid=$contextid+1; # Esto es una chapuza habría que "update" cuando
                             # se haga mdl_course_modules_insert
    
    finSub($Sub);
    return $contextid;
}

sub mdl_h5p_id{
    my $name=shift;
    my $Sub="mdl_h5p_Contextid";
    iniSub($Sub);
    
    my $consulta="select id from mdl_h5pactivity where name='$name'";  
    printT "$consulta\n"; 
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    ($contextid)=$sth->fetchrow_array() || 
	die {Pausa("Tenemos un problema con el nombre '$name' el hp5")};
    
#while(siono("contextid=$contextid; pulsar y para continuar",'si','no') eq 'si') {}; 
    finSub($Sub);
    return $contextid;
}

