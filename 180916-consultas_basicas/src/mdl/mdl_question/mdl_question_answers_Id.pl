#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_answers_Id\n";

sub mdl_question_answers_Id{
    my $question=shift;
    my $answer=shift;
    my $Sub="mdl_question_answers_Id";
    iniSub($Sub);
    
    
    my $consulta="select id from mdl_question_answers where question='".$question."' and answer='".$answer."'";  
    printT "$consulta\n";  
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    ($id)=$sth->fetchrow_array();      
    
    finSub($Sub);
    return ($id);
}
