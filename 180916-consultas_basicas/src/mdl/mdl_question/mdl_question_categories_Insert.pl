#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_categories_Insert\n";

sub mdl_question_categories_Insert{    
    my $shortname=shift;
    my $name=shift;
    my $parent=shift;
    my $Sub="mdl_question_categories_Insert";
    iniSub($Sub);
    
    $id=mdl_question_categories_Id($shortname,$name);
    if (!defined($id)) {
	$consulta1="insert into mdl_question_categories (name,parent,contextid,info,stamp) values('$name','$parent','$contextid','','".stamp()."+$name')";
	printT "$consulta1\n";	

	$dbh->do($consulta1)||die $consulta1;
	
        #$id=last_insert_Id();  #mysql. No funciona en psql
	$id=mdl_question_categories_Id($shortname,$name);
    }
    
    finSub($Sub);
    return $id;   
}
