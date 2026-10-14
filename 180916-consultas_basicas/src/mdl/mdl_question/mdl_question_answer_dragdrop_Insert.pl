#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_answers_dragdrop_Insert\n";

sub mdl_question_answers_dragdrop_Insert{
    my $name=shift;
    my $category=shift;
    my $image=shift;
    my $dragdrop=shift;
    my $drop=shift;
    my $Sub="mdl_question_answers_dragdrop_Insert";
    iniSub($Sub);  
    pausa("yuuuuupi-> drop=$drop");
    $question=mdl_question_Insert($name,$category,$questiontext,'ddimageortext');
#    pausa('ahora tiene que haber una pregunta mas ddimage...');
    my $ndrag = $dragdrop =~ tr/;//;
    my @drags = split /;/, $dragdrop;
    $ndrag++;
#    $answers='';
    $drop= mdl_question_drops_Insert($question,0,37,$drop);
    for($idrag=0;$idrag<$ndrag;$idrag++) {
	pausaT("$Sub:dragdrop=$dragdrop....$drags[$idrag]");
	$drag= mdl_question_drags_Insert($question,$idrag,$drags[$idrag]);
        #mdl_question_image_Insert($id,$image,'qtype_ddimageortext','dragimage') if ($image ne '');
#	$answers="$answer,$answers";
    }
    #  chop($answers);
    pausa("200126....el error? image=$image");
    mdl_question_dragdrop_Insert($question,$image);
    
    finSub($Sub);
    return $question;
}
