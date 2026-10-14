#!/usr/bin/perl
#

print "Incluyendo fichero: excel_question\n";

sub excel_question{
    my $Sub="excel_question";
    $excel_question=shift;
    iniSub($Sub);
    
    my $consulta="select id,name, questiontext, answer, tolerance from $excel_question where id is not null";  
    printT "$consulta\n";
    
    my $sth=$dbh_excel->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "id= $row[0], name=$row[1], questiontext=$row[2], answer=$row[3], tolerance=$row[4]\n";      
    }
    $sth->finish();

    finSub($Sub);
}
