#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question\n";

sub mdl_question{
    my $Sub="mdl_question";
    iniSub($Sub);
    
    my $consulta="select id,name,category, questiontext from mdl_question";  
    printT "$consulta\n";
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "id= $row[0], name=$row[1], category=$row[2], questiontext=$row[3]\n";      
    }
    
    finSub($Sub);
}
