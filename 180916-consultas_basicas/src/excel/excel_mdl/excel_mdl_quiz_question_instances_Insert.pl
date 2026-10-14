#!/usr/bin/perl
#

print "Incluyendo fichero: excel_mdl_quiz_question_instances_Insert\n";

sub excel_mdl_quiz_question_instances_Insert{
    my $excel_quiz_question_instances=shift;
    my $Sub="excel_mdl_quiz_question_instances_Insert";
    iniSub($Sub);

    
    my $consulta="select id, quiz, question, category, grade from $excel_quiz_question_instances where id is not null";  
    printT "$consulta\n"; 
    
    my $sth=$dbh_excel->prepare($consulta);
    $sth->execute();
    while (my ($slot, $quiz,$question,$category,$grade)=$sth->fetchrow_array()) {
	Pausa("excel_mdl_quiz_question_instances_Insert",
	      "$quiz,$question,$category,$grade");
	#pausa("quiz=$quiz,question=$question,category=$category,grade=$grade");
	$idquiz=mdl_quiz_Id($quiz,$courseid);
	$idcategory=mdl_question_categories_Id($shortname,$category);
	$idquestion=mdl_question_Id($question,$idcategory);

	#my $consulta="insert into mdl_quiz_question_instances (quiz, question, grade) VALUES ($idquiz,$idquestion,1)";  
	#printT "$consulta\n";  

	#$dbh->do($consulta)||die "$consulta";
	
	if (is_mdl_release_ge(3)){
	    mdl_quiz_slots_Insert($idquiz,$idquestion,$grade,$slot);
	    mdl_quiz_sections_Insert($idquiz);
	} else {
	    mdl_quiz_question_instances_Insert($idquiz,$idquestion,$grade,
					       $slot);  
	    mdl_quiz_question_instances_Delete();
	}
	mdl_quiz_Update($idquiz);
    }
    if (is_mdl_release_ge(3)){
	mdl_quiz_slots_Delete();
	mdl_quiz_sections_Delete();
    }
    finSub($Sub);
}
