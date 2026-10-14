#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_quiz_question_instances_Delete\n";

sub mdl_quiz_slots_Delete{
    my $Sub="mdl_quiz_slots_Delete";
    iniSub($Sub);

    is_mdl_release_ge_or_die(3);
    
    my $consulta;
    $consulta="delete from mdl_quiz_slots where quizid not in (select id from mdl_quiz)";   
  
    printT "$consulta\n";
  
    $dbh->do($consulta) || die "$consulta";;
    
    
    finSub($Sub);
}
