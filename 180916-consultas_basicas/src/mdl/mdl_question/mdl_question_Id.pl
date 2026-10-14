#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_Id\n";

sub mdl_question_Id{
    my $name=shift;
    my $category=shift;
    my $Sub="mdl_question_Id";
    iniSub($Sub);
    
    my $consulta="select id from mdl_question where name='".$name."' and category='".$category."'";  
    printT "$consulta\n";  
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    ($id)=$sth->fetchrow_array();      
    
    finSub($Sub);
    return ($id);
}
