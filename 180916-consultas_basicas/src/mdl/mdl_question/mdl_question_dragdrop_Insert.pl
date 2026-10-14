#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_dragdrop_Insert\n";

sub mdl_question_dragdrop_Insert{
    my $question=shift;
    my $image=shift;
    my $Sub="mdl_question_dragdrop_Insert";
    iniSub($Sub);
    Pausa("Pendiente",
	  "mdl_question_dragdrop_Delete();",
	"answers=$answers");

    my $consulta="insert into mdl_qtype_ddimageortext (questionid,shuffleanswers,correctfeedback,partiallycorrectfeedback,incorrectfeedback) VALUES ($question,1,' ',' ', ' ')";  
    printT "$consulta\n";  

    $dbh->do($consulta)||die "$consulta";
       
    mdl_question_image_Insert($question,$image,'qtype_ddimageortext','bgimage') if ($image ne '');
 
    finSub($Sub);
}
