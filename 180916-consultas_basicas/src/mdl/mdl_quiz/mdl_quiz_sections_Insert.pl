#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_quiz_sections_Insert\n";

sub mdl_quiz_sections_Insert{
    my $Sub="mdl_quiz_sections_Insert";
    my $id=shift;
    iniSub($Sub);
    
    is_mdl_release_ge_or_die(3);
    
    my $consulta;
    $consulta = "insert into mdl_quiz_sections (quizid,firstslot) VALUES ($id, 1)";
    $dbh->do($consulta); #|| die "$consulta\n";
	
   
    
    finSub($Sub);
}
