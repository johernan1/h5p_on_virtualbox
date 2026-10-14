#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_numerical_Insert\n";

sub mdl_question_numerical_Insert{
    my $question=shift;
    my $answer=shift;
    my $tolerance=shift;
    my $Sub="mdl_question_numerical_Insert";
    iniSub($Sub);
    
    mdl_question_numerical_Delete();

    my $consulta="insert into mdl_question_numerical (question,answer,tolerance) VALUES ($question,$answer,$tolerance)";  
    printT "$consulta\n";  

    $dbh->do($consulta)||die "$consulta";
        
    finSub($Sub);
}
