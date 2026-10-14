#!/usr/bin/perl
#

use Cwd;

print "Incluyendo fichero: excel_variables\n";

sub excel_variables{
    my $Sub="excel_variables";
    iniSub($Sub);

    ##### Variables globales
    $shortname='c1';
    $ejercicio='ejercicio';
    $semana=1;
    $debug=1;
    #$moodledata='C:\Documents and Settings\etsam\Escritorio\moodle\server\moodledata';
    $excel_question='excel_question';
    $excel_question_categories='excel_question_categories';
    $excel_quiz='excel_quiz';
    $excel_quiz_question_instances='excel_quiz_question_instances';
    $excel_course_modules='excel_course_modules';
    $excel_groupings_groups='excel_groupings_groups';
    $excel_quiz_intro="";
 
    if (grep {/excel_variables/} $dbh_excel->tables()) {
	my $consulta="select var, val from excel_variables";  
	printT "$consulta\n"; 
    
	my $sth=$dbh_excel->prepare($consulta);
	$sth->execute();
	while (@row=$sth->fetchrow_array()) {
	    printT "\$$row[0]=\"$row[1]\"\n";  
	    scalar eval "\$$row[0]=\"$row[1]\"\n";      
	}
    }
    if ($debug==0) {
	sub nada{};
	#sub sionoDebug {$texto=shift;$por_defecto= shift; return $por_defecto;}
	*printT = \&nada;
	*iniSub = \&nada;
	*finSub = \&nada;
	*pausa  = \&nada;
	*pausaT  = \&nada;
	*Pausa  = \&nada;
	*_Pausa  = \&nada;
	#*siono  = \&sionoDebug;
    }
    $courseid=mdl_course_Id($shortname);
#foreach $key (sort keys(%ENV)){
#   print "$key = $ENV{$key}\n";
#}
#print getcwd;
#    print "\n----";
#    print $0;
#    pausa();
#    #exit();
    finSub($Sub);
}
