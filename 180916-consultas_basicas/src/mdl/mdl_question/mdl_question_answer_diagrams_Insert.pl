#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_answers_diagrams_Insert\n";

sub mdl_question_answers_diagrams_Insert{
    my $name=shift;
    my $category=shift;
    my $questiontext=shift;
    my $answer=shift;
    my $tolerance=shift;
    my $diagGeom=shift;
    my $diagEsf=shift;
    my $Sub="mdl_question_answers_diagrams_Insert";
    iniSub($Sub);  

    $question=mdl_question_Insert($name,$category,$questiontext,'diagrams');
    my $nbar = $diagGeom =~ tr/;//;
    $nbar++;
    $answers='';
    for($ibar=$nbar;$ibar>0;$ibar--) {
	$answer= mdl_question_answers_Insert($question,$ibar,$ibar/$nbar);
	$answers="$answer,$answers";
    }
    chop($answers);
    mdl_question_diagrams_Insert($question,$answers,$tolerance,
				 $diagGeom,$diagEsf);
    
    finSub($Sub);
    return $question;
}
