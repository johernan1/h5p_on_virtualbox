#!/usr/bin/perl
#

print "Incluyendo fichero: excel_mdl_question_answers_numerical_Insert\n";

sub excel_mdl_question_categories_Insert {
    my $Sub="excel_mdl_question_categories_Insert";
    $excel_question_categories=shift;
    iniSub($Sub);
    
    my $consulta="select id, name, parent from $excel_question_categories where id is not null order by id"; 

    printT "$consulta\n";
    
    my $sth=$dbh_excel->prepare($consulta);
    $sth->execute();
    while (my ($id, $name, $parent)=$sth->fetchrow_array()) {
	printT "id= $id, name=$name, parent=$parent\n";
	$idparent=mdl_question_categories_Id($shortname,$parent) ||
	          mdl_question_categories_Id($shortname,
			    "Default for ".mdl_course_Fullname($shortname)) ||
	          mdl_question_categories_Id($shortname,
			    "Por defecto en ".mdl_course_Fullname($shortname));;
	mdl_question_categories_Insert($shortname,$name,$idparent);
    }
    
    finSub($Sub);
}


