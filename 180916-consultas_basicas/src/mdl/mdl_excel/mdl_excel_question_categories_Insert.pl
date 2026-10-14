#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_excel_question_answers_numerical_Insert\n";

sub mdl_excel_question_categories_Insert {
    my $Sub="mdl_excel_question_categories_Insert";
    $excel_question_categories=shift;
    iniSub($Sub);
    
    $contextid=mdl_question_categories_Contextid($shortname);
    
    my $consulta="select id, name,  parent from mdl_question_categories where contextid=$contextid"; 

    printT "$consulta\n";
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (my ($id, $name, $parent)=$sth->fetchrow_array()) {
	printT "id= $id, name=$name, parent=$parent\n";
	#$idparent=mdl_question_categories_Id($shortname,$parent);
	#mdl_question_categories_Insert($shortname,$name,$idparent);
	$nameparent=mdl_question_categories_Name($shortname,$parent);
	excel_question_categories_Insert($excel_question_categories,$name,$nameparent);
    }
    
    finSub($Sub);
}


