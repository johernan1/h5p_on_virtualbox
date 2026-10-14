#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_course_sections\n";

sub mdl_course_sections{
    my $Sub="mdl_course_sections";
    iniSub($Sub);

    my $consulta="select course, section, sequence from mdl_course_sections order by section";  
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "course=$row[0], section(semana)=$row[1], sequence=$row[2]\n";      
    }
        
    finSub($Sub);
}
