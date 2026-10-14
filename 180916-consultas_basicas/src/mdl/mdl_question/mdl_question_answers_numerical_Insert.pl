#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_answers_numerical_Insert\n";

sub mdl_question_answers_numerical_Insert{
    my $name=shift;
    my $category=shift;
    my $questiontext=shift;
    my $answer=shift;
    my $tolerance=shift;
    my $Sub="mdl_question_answers_numerical_Insert";
    iniSub($Sub);
    
    $question=mdl_question_Insert($name,$category,$questiontext);
    $answer= mdl_question_answers_Insert($question,$answer);
    mdl_question_numerical_Insert($question,$answer,$tolerance);
    
    finSub($Sub);
    return $question;
}
