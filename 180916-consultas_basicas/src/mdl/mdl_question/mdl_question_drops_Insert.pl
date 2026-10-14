#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_drops_Insert\n";

sub mdl_question_drops_Insert{
    my $question=shift;
    my $x=shift;
    my $y=shift;
    my $drop=shift;
    #if($fraction eq '') {$fraction=1;};

    my $Sub="mdl_question_drops_Insert";
    iniSub($Sub);
 
   
    Pausa("Pendiente",
	  "mdl_question_drops_Delete();");
#    mdl_question_answers_Delete();
    
    
    my $consulta="insert into mdl_qtype_ddimageortext_drops (questionid,no,xleft,ytop,choice,label) VALUES ($question,1,$x,$y,$drop,' ')";  
    printT "$consulta\n";  
    
    $dbh->do($consulta)||die "$consulta";

    $id=last_insert_Id("mdl_qtype_ddimageortext_drops");
    finSub($Sub);
    return $id
}
