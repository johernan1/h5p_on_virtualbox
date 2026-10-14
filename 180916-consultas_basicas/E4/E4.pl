#!
#!c:/strawberry/perl/bin/perl.exe
$mypath="$0";$mypath=~s/E4.pl//;
do $mypath.'src/do.pl';

##############################################################################
#restore("dat/backupE4.sql")  mysql+moodle2
restore("$mypath/dat/backup393.sql")
    if(siono("Se restaura la base de moodle?",'no','si')eq'si');
$excel=$ARGV[0];
$excel=fichero("excel1.xls") if (not -f $ARGV[0]);
$exceldir=$excel;    $exceldir=~s:[/\\][^/\\]*$::g;
$excel=tmpfichero($excel) 
    if(siono("Se manipula una copia del fichero?",'si','no')eq'si');
inicioDbiExcel("$excel");
inicioDbi();
excel_variables();
##############################################################################
excel_("$excel_question"); 
excel_variables();
pausa("v 170916");
excel_mdl_question_categories_Insert("$excel_question_categories");
pausa();
excel_mdl_quiz_Insert("$excel_quiz");
pausa();
excel_mdl_groupings_groups_Insert("$excel_groupings_groups");
pausa();
excel_mdl_course_modules_Insert("$excel_course_modules");
pausa();
excel_mdl_question_answers_numerical_Insert("$excel_question");
pausa();
excel_mdl_quiz_question_instances_Insert("$excel_quiz_question_instances");
Pausa("Fin");

