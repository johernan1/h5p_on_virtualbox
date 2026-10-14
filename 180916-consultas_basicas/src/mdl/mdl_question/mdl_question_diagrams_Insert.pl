#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_diagrams_Insert\n";

sub mdl_question_diagrams_Insert{
    my $question=shift;
    my $answers=shift;
    my $tolerance=shift;
    my $diagGeom=shift;
    my $diagEsf=shift;
    my $Sub="mdl_question_diagrams_Insert";
    iniSub($Sub);
    Pausa("Pendiente",
	  "mdl_question_diagrams_Delete();",
	"answers=$answers");

    my $consulta="insert into mdl_question_diagrams (question,answers,internalforceserror,topology,graphofinternalforces) VALUES ($question,'$answers',$tolerance,'$diagGeom','$diagEsf')";  
    printT "$consulta\n";  

    $dbh->do($consulta)||die "$consulta";
        
    finSub($Sub);
}
