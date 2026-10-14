#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_excel_question_answers_numerical_Insert\n";

sub mdl_excel_question_answers_numerical_Insert {
    my $Sub="mdl_excel_question_answers_numerical_Insert";
    $excel_question=shift;
    iniSub($Sub);
    
    
    my $consulta="select mdl_question.name, mdl_question_categories.name as category, questiontext, mdl_question_answers.answer, tolerance, image from mdl_question, mdl_question_numerical, mdl_question_answers, mdl_question_categories where mdl_question_answers.question=mdl_question.id and mdl_question_numerical.question=mdl_question.id and mdl_question_categories.id=mdl_question.category";#  and course=$courseid";  
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (my ($name,$category,$questiontext,$answer,$tolerance,$image)=$sth->fetchrow_array()) {
	$questiontext=~s/'//g;
	#pausa("$name,$category,$questiontext,$answer,$tolerance,$grade")
	excel_question_Insert($excel_question,
			      $name,$category,$questiontext,$answer,
			      $tolerance,$image);
    }
    finSub($Sub);
}

