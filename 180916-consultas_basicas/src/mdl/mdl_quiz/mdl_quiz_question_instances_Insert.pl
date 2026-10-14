#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_quiz_question_instances_Insert\n";

sub mdl_quiz_question_instances_Insert{
    my $quiz=shift;
    my $question=shift;
    my $grade=shift;
    my $slot=shift;
    my $Sub="mdl_quiz_question_instances_Insert";
    iniSub($Sub);
    
    is_mdl_release_le_or_die(2);
    my $consulta;
    $consulta="insert into mdl_quiz_question_instances (quiz, question, grade) VALUES ($quiz,$question,1)";
    
    printT "$consulta\n";  

    $dbh->do($consulta)||die "$consulta";
        
    finSub($Sub);
}
