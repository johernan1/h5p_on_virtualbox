#!c:/strawberry/perl/bin/perl.exe
$mypath="$0";$mypath=~s/H5P.pl//;$mypath="$mypath../";
do $mypath.'src/do.pl';

##############################################################################
$excel=$ARGV[0];
$excel=fichero("excel1.xls") if (not -f $ARGV[0]);
$exceldir=$excel;    $exceldir=~s:[/\\][^/\\]*$::g;
$excel=tmpfichero($excel) 
    if(siono("Se manipula una copia del fichero?",'si','no')eq'si');
inicioDbiExcel("$excel");
inicioDbi();
# Hay que ajustar mdl_contex
#                 mdl_course_modules
#                 mdl_files
#                 mdl_grade_items
excel_variables();
##############################################################################
excel_("excel_h5p");
excel_variables();
pausa("v 191228");
#excel_mdl_question_categories_Insert("$excel_question_categories");
#pausa();
#excel_mdl_quiz_Insert("$excel_quiz");
excel_mdl_h5p_Insert("excel_h5p");
#pausa();
excel_mdl_groupings_groups_Insert("$excel_groupings_groups");
#pausa();
excel_mdl_course_modules_Insert("$excel_course_modules","h5pactivity");
#pausa();
#excel_mdl_question_answers_numerical_Insert("$excel_question");
#excel_mdl_h5p_Insert("excel_h5p");
#pausa();
#excel_mdl_quiz_question_instances_Insert("$excel_quiz_question_instances");
Pausa("Fin");

