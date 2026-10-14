#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_categories_Contextid\n";

sub mdl_question_categories_Contextid{
    my $shortname=shift;
    my $Sub="mdl_question_categories_Contextid";
    iniSub($Sub);
    my $fullname=mdl_course_Fullname($shortname);
    
    my $consulta="select contextid from mdl_question_categories where name='Default for $fullname' or name='Por defecto en $fullname'";  
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    ($contextid)=$sth->fetchrow_array() || 
	die {Pausa("No existe la categoria 'Default for $fullname'","",
		   "Si es un curso nuevo pinchar en menu 'preguntas' para que se cree")};
    
    finSub($Sub);
    return $contextid;
}


