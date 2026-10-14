#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_answers\n";

sub mdl_question_answers{
    my $Sub="mdl_question_answers";
    iniSub($Sub);
    
    my $consulta="select question, answer from mdl_question_answers";  
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "question=$row[0], answer=$row[1]\n";      
    }
    
    finSub($Sub);
}
