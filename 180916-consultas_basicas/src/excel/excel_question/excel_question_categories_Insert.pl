#!/usr/bin/perl
#

print "Incluyendo fichero: excel_question_categories_Insert\n";

sub excel_question_categories_Insert{    
    my $excel_question_categories=shift;
    my $name=shift;
    my $parent=shift;
    my $Sub="excel_question_categories_Insert";
    iniSub($Sub);
    
    $id=excel_question_categories_Id($excel_question_categories,$name);
    if (!defined($id)) {
	$id=excel_last_insert_Id($excel_question_categories);
        $id++;
	$consulta1="insert into $excel_question_categories (id,name,parent) values('$id','$name','$parent')";
	printT "$consulta1\n";	

	$dbh_excel->do($consulta1);
	
    }
    
    finSub($Sub);
    return $id;   
}
