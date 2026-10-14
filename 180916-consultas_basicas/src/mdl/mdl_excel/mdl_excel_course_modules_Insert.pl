#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_excel_course_modules_Insert\n";

sub mdl_excel_course_modules_Insert{
    my $Sub="mdl_excel_course_modules_Insert";
    my $excel_course_modules=shift;
    iniSub($Sub);
    my $quizId=mdl_modules_Id("quiz");

    my $consulta="select section,mdl_quiz.name as instance,mdl_groupings.name as grouping from  mdl_course_modules,mdl_quiz,mdl_groupings where instance=mdl_quiz.id and groupingid=mdl_groupings.id and mdl_quiz.course=$courseid and module= $quizId UNION select section,mdl_quiz.name as instance,'' as groupingid from  mdl_course_modules,mdl_quiz,mdl_groupings    where instance=mdl_quiz.id and groupingid=0 and mdl_quiz.course=$courseid and module=$quizId";
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
 pausa();
    $sth->execute();
    while (my ($section,$instance,$grouping)=$sth->fetchrow_array()) {
	excel_course_modules_Insert($excel_course_modules,$section,$instance,$grouping);
    }
    finSub($Sub);
}
