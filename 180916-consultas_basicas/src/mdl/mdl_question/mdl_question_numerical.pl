#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_numerical\n";

sub mdl_question_numerical{
    my $Sub="mdl_question_numerical";
    iniSub($Sub);
    
    my $consulta="select question, answer, tolerance from mdl_question_numerical";  
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "question=$row[0], answer=$row[1], tolerance=$row[2]\n";      
    }
        
    finSub($Sub);
    
}
