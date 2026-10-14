#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_course_modules\n";

sub mdl_course_modules{
    my $Sub="mdl_course_modules";
    iniSub($Sub);

    my $consulta="select id, course, module, instance, section from mdl_course_modules order by section";  
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "id=$row[0], course=$row[1], module=$row[2], instance=$row[3], section=$row[4]\n";      
    }
    
    finSub($Sub);
}
