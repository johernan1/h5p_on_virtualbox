#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_quiz_Update\n";

sub mdl_quiz_Update{
    my $Sub="mdl_quiz_Update";
    my $id=shift;
    iniSub($Sub);

    if (is_mdl_release_le(2)) {
	$id=mdl_quiz_Update_v2($id)
    }
    elsif (is_mdl_release_ge_or_die(3)) {
	$id=mdl_quiz_Update_v3($id)
    };
    
    finSub($Sub);
}

sub mdl_quiz_Update_v3{
    my $Sub="mdl_quiz_Update_v3";
    my $id=shift;
    iniSub($Sub);
    
    is_mdl_release_ge_or_die(3);
    
    my $consulta; 
    $consulta="select sum(maxmark) from mdl_quiz_slots where quizid=$id ";
    
    printT "$consulta\n";
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    ($sumgrades)=$sth->fetchrow_array();
    
    ########################################################################
    my $consulta="update mdl_quiz set sumgrades=$sumgrades where id=$id";
    printT "$consulta\n"; 
    
    $dbh->do($consulta) || die "$consulta\n";

    finSub($Sub);
}


sub mdl_quiz_Update_v2{
    my $Sub="mdl_quiz_Update_v2";
    my $id=shift;
    iniSub($Sub);
    
    is_mdl_release_le_or_die(2);
    
    my $consulta; 
    $consulta="select question from mdl_quiz_question_instances where quiz=$id order by (-id)";
    
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    $questions="0";
    $sumgrades=0;
    while (($question)=$sth->fetchrow_array()) {
	$questions="$question,$questions";      
	$sumgrades++;
    }
    
    ########################################################################
    my $consulta="update mdl_quiz set questions='$questions' where id=$id"; 
    printT "$consulta\n"; 
    
    $dbh->do($consulta) || die "$consulta\n";  
    
    ########################################################################
    my $consulta="update mdl_quiz set sumgrades=$sumgrades where id=$id";
    printT "$consulta\n"; 
    
    $dbh->do($consulta) || die "$consulta\n";

    finSub($Sub);
}
sub mdl_quiz_Update_v2{
    my $Sub="mdl_quiz_Update_v2";
    my $id=shift;
    iniSub($Sub);
    
    is_mdl_release_le_or_die(2);
    
    my $consulta; 
    $consulta="select question from mdl_quiz_question_instances where quiz=$id order by (-id)";
    
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    $questions="0";
    $sumgrades=0;
    while (($question)=$sth->fetchrow_array()) {
	$questions="$question,$questions";      
	$sumgrades++;
    }
    
    ########################################################################
    my $consulta="update mdl_quiz set questions='$questions' where id=$id"; 
    printT "$consulta\n"; 
    
    $dbh->do($consulta) || die "$consulta\n";  
    
    ########################################################################
    my $consulta="update mdl_quiz set sumgrades=$sumgrades where id=$id";
    printT "$consulta\n"; 
    
    $dbh->do($consulta) || die "$consulta\n";

    finSub($Sub);
}
