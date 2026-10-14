#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_categories_Name\n";

sub mdl_question_categories_Name{
    my $shortname=shift;
    my $id=shift;
    my $Sub="mdl_question_categories_Name";
    iniSub($Sub);
    
    my $consulta="select name from mdl_question_categories where id='$id' and contextid=".mdl_question_categories_Contextid($shortname);  
    printT "$consulta\n";  
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    ($name)=$sth->fetchrow_array();# || die "No existe la categoria '$name'\n";
    
    finSub($Sub);
    return $name;
}


