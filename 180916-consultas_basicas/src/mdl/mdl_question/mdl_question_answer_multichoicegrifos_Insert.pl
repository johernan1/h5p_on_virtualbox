#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_answers_multichoicegrifos_Insert\n";

sub mdl_question_answers_multichoicegrifos_Insert{
    my $name=shift;
    my $category=shift;
    # my $image=shift;
    my $multichoicegrifos=shift;
    my $choice=shift;
    my $Sub="mdl_question_answers_multichoicegrifos_Insert";
    iniSub($Sub);  
#    pausa("yuuuuupi-> choice=$choice");
    $question=mdl_question_Insert($name,$category,$questiontext,'multichoice');

    pausa("ahora tiene que haber una pregunta mas multichoice..., la numero $question");
    my $nAnswers = $multichoicegrifos =~ tr/;//;
    my @Answerss = split /;/, $multichoicegrifos;
    $nAnswers++;
    $answers='';

    for($iAnswers=0;$iAnswers<$nAnswers;$iAnswers++) {
	pausa("multichoicegrifos=$multichoicegrifos....$Answerss[$iAnswers]");
        #---------------------------------------------------------------------
        # Se cambia elnombre del fichero para "ofuscar" la pregunta
	$ficheroOfuscado=last_insert_Id("mdl_question");
        
	$questiontext="<p> <img style=\"vertical-align: middle; display: block; margin-left: auto; margin-right: auto;\" hspace=\"0\" border=\"0\"  width=50%\" vspace=\"0\" src=\"\@\@PLUGINFILE\@\@/$Answerss[$iAnswers]\" /><br /><p/> ";
	$questiontext="<p> <img style=\"vertical-align: middle;  width=50%\" src=\"\@\@PLUGINFILE\@\@/$Answerss[$iAnswers]\" /><br /><p/> ";
	
	$questiontext="<p> <img style=\"vertical-align: middle;  width=50%\" src=\"\@\@PLUGINFILE\@\@/$ficheroOfuscado\" /><br /><p/> ";
        if ($iAnswers+1 eq $choice) { 
	    $answer=mdl_question_answers_Insert($question,
						$questiontext,1);
	} else { 
	    $answer=mdl_question_answers_Insert($question,
						$questiontext,0);
	}
        my $consulta = "update mdl_question_answers set answerformat=1 where id=$answer";
	$dbh->do($consulta)||die "$consulta";

	# De este modo no se "ofusca" la pregunta
	# mdl_question_image_Insert($answer,$Answerss[$iAnswers],'question', 'answer');
        #---------------------------------------------------------------------
        # Se cambia elnombre del fichero para "ofuscar" la pregunta
	my $dirimage=$exceldir;
	pausa("$answer, $Answerss[$iAnswers]");
	pausa();
	pausa();
        pausa("$dirimage/$Answerss[$iAnswers]->$dirimage/$id");
        copy ("$dirimage/$Answerss[$iAnswers]", "$dirimage/$ficheroOfuscado") or die "Copy failed: $!";;
	pausa("$id");
	mdl_question_image_Insert($answer,"$ficheroOfuscado",'question', 'answer');
	unlink  ("$dirimage/$ficheroOfuscado") or die "Rm failed failed: $!";;
	pausa();

	$answers="$answer,$answers";
    }
    pausa("ahora tiene que haber $nAnswers mdl_question_answer, las numero $answers");
    chop($answers);
    mdl_question_multichoicegrifos_Insert($question,$answers);
    
    finSub($Sub);
    return $question;
}
