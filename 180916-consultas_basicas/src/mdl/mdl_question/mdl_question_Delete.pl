#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_Delete\n";

sub mdl_question_Delete{
    my $name=shift;
    my $category=shift;
    my $Sub="mdl_question_Delete";
    iniSub($Sub);
        
    my $consulta="delete from mdl_question where name='".$name."' and category='".$category."'";  
    printT "$consulta\n";  

    $dbh->do($consulta) || die "$consulta";;
    
    finSub($Sub);
}
