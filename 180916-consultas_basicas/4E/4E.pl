#!c:/strawberry/perl/bin/perl.exe
$mypath="$0";$mypath=~s/4E.pl//;
do $mypath.'src/do.pl';

##############################################################################
$excel="$mypath/excel0.xls";
$excel=tmpfichero($excel); 
pausa("Se manipula el fichero $excel");
inicioDbiExcel("$excel");
inicioDbi();
##############################################################################
excel_variables();
excel_("$excel_question");
pausa();
#mdl_excel_question_categories_Insert("$excel_question_categories");
#pausa();
#mdl_excel_quiz_Insert("$excel_quiz");
#pausa();
##mdl_excel_groupings_groups_Insert("$excel_groupings_groups");
##pausa();
mdl_excel_course_modules_Insert("$excel_course_modules");
pausa();
#mdl_excel_question_answers_numerical_Insert("$excel_question");
#pausa();
mdl_excel_quiz_question_instances_Insert("$excel_quiz_question_instances");
pausa();

$dbh_excel->func('save');
