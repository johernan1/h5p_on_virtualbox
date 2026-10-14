#!/usr/bin/perl
#

print "Incluyendo fichero: excel_quiz_question_instances_Insert\n";

sub excel_quiz_question_instances_Insert{
    my $excel_quiz_question_instances= shift;
    #my ,"$course_$ejercicio","$name","$category","$grade"
    my $quiz=shift;
    my $question=shift;
    my $category=shift;
    my $grade=shift;
    my $Sub="excel_quiz_question_instances_Insert";
    iniSub($Sub);

    my $id=excel_last_insert_Id($excel_quiz_question_instances);
    $id++;

    my $consulta="insert into $excel_quiz_question_instances (id, quiz, question,category, grade) VALUES ($id,'$quiz','$question','$category',$grade)";  
    printT "$consulta\n";  

    $dbh_excel->do($consulta)||die "$consulta";
        
    finSub($Sub);
}
