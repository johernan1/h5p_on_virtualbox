#!/usr/bin/perl
#

print "Incluyendo fichero: excel_question_categories\n";

sub excel_question_categories{
    my $Sub="excel_question_categories";
    $excel_question_categories=shift;
    iniSub($Sub);
    
    my $consulta="select id, name, parent from $excel_question_categories where id is not null order by id"; 

    printT "$consulta\n";
    
    my $sth=$dbh_excel->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "id= $row[0], name=$row[1], parent=$row[2]\n";      
    }
    
    finSub($Sub);
}
