#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_multichoicegrifos_Insert\n";

sub mdl_question_multichoicegrifos_Insert{
    my $question=shift;
    my $answers=shift;
    my $Sub="mdl_question_multichocegrifos_Insert";
    iniSub($Sub);
    Pausa("Pendiente",
	  "mdl_question_multichoicegrifos_Delete();",
	  "answers=$answers");
    
    if (is_mdl_release_eq(3)){
	my $consulta="insert into mdl_qtypen_multichoice_options (question,shuffleanswers,answers, answernumbering,single) VALUES ($question,1,'$answers', 'none',1)";  
    } elsif (is_mdl_release_le_or_die(2)) {
	my $consulta="insert into mdl_question_multichoice (question,shuffleanswers,answers, answernumbering,single) VALUES ($question,1,'$answers', 'none',1)";
    }
    printT "$consulta\n";
	

    $dbh->do($consulta)||die "$consulta";
       
    #mdl_question_image_Insert($question,$image,'qtype_ddimageortext','bgimage') if ($image ne '');
 
    finSub($Sub);
}
