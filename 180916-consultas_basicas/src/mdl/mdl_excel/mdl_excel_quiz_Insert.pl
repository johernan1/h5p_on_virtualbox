#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_excel_quiz_Insert\n";

sub mdl_excel_quiz_Insert{
    my $Sub="mdl_excel_quiz_Insert";
    $excel_quiz=shift;
    iniSub($Sub);
    

    my $consulta="select id, name, intro from mdl_quiz where course=$courseid";  
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (my ($id, $name, $intro)=$sth->fetchrow_array()) {
	#$intro=~s/--/- -/g; #¿¿¿Errata en SQL Statement.pm???
	#$intro=~s/\n/ /g;	
	excel_quiz_Insert($excel_quiz,$name,$intro);

    }
    finSub($Sub);
}
