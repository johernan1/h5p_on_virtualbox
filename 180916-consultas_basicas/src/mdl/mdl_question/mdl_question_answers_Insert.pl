#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_answers_Insert\n";

sub mdl_question_answers_Insert{
    my $question=shift;
    my $answer=shift;
    my $fraction=shift;
    if($fraction eq '') {$fraction=1;};
   
    my $Sub="mdl_question_answers_Insert";
    iniSub($Sub);
    
    mdl_question_answers_Delete();
    
    my $consulta="insert into mdl_question_answers (question,answer,fraction,feedback) VALUES ($question,'$answer','$fraction','\"')";  
    printT "$consulta\n";  
    
    $dbh->do($consulta)||die "$consulta";
    
    $id=last_insert_Id("mdl_question_answers");
    finSub($Sub);
    return $id
}
