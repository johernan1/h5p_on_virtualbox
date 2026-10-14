#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_categories\n";

sub mdl_question_categories{
    my $Sub="mdl_question_categories";
    iniSub($Sub);
    
    my $consulta="select id, name, parent,contextid from mdl_question_categories order by parent";  
    printT "$consulta\n";  
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "id=$row[0], name=$row[1], parent=$row[2], contextid=$row[3]\n";      
    }
    
    finSub($Sub);
}


