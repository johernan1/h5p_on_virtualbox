#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_numerical_Delete\n";

sub mdl_question_numerical_Delete{
    my $Sub="mdl_question_numerical_Delete";
    iniSub($Sub);
    
    my $consulta="delete from mdl_question_numerical where question not in (
                      select id from mdl_question)";  
    printT "$consulta\n";  

    $dbh->do($consulta) || die "$consulta";;
    
    finSub($Sub);
}
