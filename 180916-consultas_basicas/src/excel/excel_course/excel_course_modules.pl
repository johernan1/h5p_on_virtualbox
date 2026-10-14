#!/usr/bin/perl
#

print "Incluyendo fichero: excel_course_modules\n";

sub excel_course_modules{
    my $Sub="excel_course_modules";
    $excel_course_modules=shift;
    iniSub($Sub);

    my $consulta="select id, instance, section from $excel_course_modules order by section";  
    printT "$consulta\n"; 
    
    my $sth=$dbh_excel->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "id=$row[0], instance=$row[1], section=$row[2]\n";      
    }
    
    finSub($Sub);
}
