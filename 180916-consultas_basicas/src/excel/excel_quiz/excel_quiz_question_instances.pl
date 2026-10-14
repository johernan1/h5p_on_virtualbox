#!/usr/bin/perl
#

print "Incluyendo fichero: excel_quiz_question_instances\n";

sub excel_quiz_question_instances{
    my $Sub="excel_quiz_question_instances";
    $excel_quiz_question_instances=shift;
    iniSub($Sub);

    my $consulta="select quiz, question, grade from $excel_quiz_question_instances";  
    printT "$consulta\n"; 
    
    my $sth=$dbh_excel->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "quiz=$row[0], question=$row[1], grade=$row[2]\n";      
    }
        
    finSub($Sub);
}
