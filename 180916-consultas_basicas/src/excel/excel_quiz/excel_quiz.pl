#!/usr/bin/perl
#

print "Incluyendo fichero: excel_quiz\n";

sub excel_quiz{
    my $Sub="excel_quiz";
    $excel_quiz=shift;
    iniSub($Sub);

    my $consulta="select id, name, intro from $excel_quiz";  
    printT "$consulta\n"; 
    
    my $sth=$dbh_excel->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "id=$row[0], name=$row[1], intro=$row[2]\n";      
    }
        
    finSub($Sub);
}
