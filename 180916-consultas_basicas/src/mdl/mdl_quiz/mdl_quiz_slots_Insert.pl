#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_quiz_question_instances_Insert\n";

sub mdl_quiz_slots_Insert{
    my $quiz=shift;
    my $question=shift;
    my $grade=shift;
    my $slot=shift;
    my $Sub="mdl_quiz_slots_Insert";
    iniSub($Sub);

    my $consulta;
    is_mdl_release_ge_or_die(3);
    
    my $consulta;
    $consulta = "insert into mdl_quiz_slots (quizid, slot, questionid, page, maxmark) VALUES ($quiz, $slot, $question, 1, $grade)";
    
    printT "$consulta\n";  

    $dbh->do($consulta)||die "$consulta";
        
    finSub($Sub);
}
