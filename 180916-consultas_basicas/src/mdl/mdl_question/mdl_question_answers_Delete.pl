#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_answers_Delete\n";

sub mdl_question_answers_Delete{
    my $Sub="mdl_question_answers_Delete";
    iniSub($Sub);
    
    my $consulta="delete from mdl_question_answers where question not in (
                      select id from mdl_question)";  
    printT "$consulta\n";  

    $dbh->do($consulta) || die "$consulta";;
    
    finSub($Sub);
}
