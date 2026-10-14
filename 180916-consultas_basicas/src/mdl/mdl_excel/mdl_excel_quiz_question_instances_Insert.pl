#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_excel_quiz_question_instances_Insert\n";

sub mdl_excel_quiz_question_instances_Insert{
    my $excel_quiz_question_instances=shift;
    my $Sub="mdl_excel_quiz_question_instances_Insert";
    iniSub($Sub);

    
    my $consulta="select mdl_quiz.name as quiz, mdl_question.name as question, mdl_question_categories.name as category, mdl_quiz_question_instances.grade as grade from mdl_quiz_question_instances, mdl_quiz, mdl_question, mdl_question_categories where mdl_quiz.id=mdl_quiz_question_instances.quiz and mdl_question.id=mdl_quiz_question_instances.question and mdl_question_categories.id=mdl_question.category  and course=$courseid";  
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (my ($quiz,$question,$category,$grade)=$sth->fetchrow_array()) {
	excel_quiz_question_instances_Insert($excel_quiz_question_instances,
	    $quiz,$question,$category,$grade);
    }
    finSub($Sub);
}
