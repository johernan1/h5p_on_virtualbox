#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_quiz_question_instances_Delete\n";

sub mdl_quiz_question_instances_Delete{
    my $Sub="mdl_quiz_question_instances_Delete";
    iniSub($Sub);

    is_mdl_release_le_or_die(2);
    my $consulta;
    $consulta="delete from mdl_quiz_question_instances where question not in
               (select id from mdl_question)";
    
    
  
    printT "$consulta\n";
  
    $dbh->do($consulta) || die "$consulta";;
    
    
    finSub($Sub);
}
