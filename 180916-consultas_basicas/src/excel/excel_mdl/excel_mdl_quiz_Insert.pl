#!/usr/bin/perl
#

print "Incluyendo fichero: excel_mdl_quiz_Insert\n";

sub excel_mdl_quiz_Insert{
    my $Sub="excel_mdl_quiz_Insert";
    #my $name=shift;
    #my $intro=shift;
    #my $course=shift;
    $excel_quiz=shift;
    #my $grade=10;
    #my $review=8323;
    iniSub($Sub);
    

    my $consulta="select id, name, intro from $excel_quiz";  
    printT "$consulta\n"; 
    
    my $sth=$dbh_excel->prepare($consulta);
    $sth->execute();
    while (my ($id, $name, $intro)=$sth->fetchrow_array()) {
	mdl_quiz_Insert($name,$intro,$courseid);
#	#printT "id=$row[0], name=$row[1], intro=$row[2]\n";      
#    
#	my $consulta="delete from mdl_quiz where name='".$name."' and intro='".$intro."'and course='".$idcourse."'";  
#	printT "$consulta\n";  
#    
#	$dbh->do($consulta) || die "$consulta";
#    ###########################################################################
#    
#	$consulta="insert into mdl_quiz (name,intro,course,grade,review) VALUES ('$name','$intro',$idcourse,$grade,$review)";   
#	printT "$consulta\n"; 
#    
#	$dbh->do($consulta) || die "$consulta\n"; 
#    
#	$id=last_insert_Id();
    }
    finSub($Sub);
#    return($id);
}
