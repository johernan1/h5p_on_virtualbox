#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_quiz_question_instances\n";

sub mdl_quiz_question_instances{
    my $Sub="mdl_quiz_question_instances";
    iniSub($Sub);

    my $consulta="select quiz, question, grade from mdl_quiz_question_instances";  
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "quiz=$row[0], question=$row[1], grade=$row[2]\n";      
    }
        
    finSub($Sub);
}
