#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_categories_Id\n";

sub mdl_question_categories_Id{
    my $shortname=shift;
    my $name=shift;
    my $Sub="mdl_question_categories_Id";
    iniSub($Sub);
    
    my $consulta="select id from mdl_question_categories where name='$name' and contextid=".mdl_question_categories_Contextid($shortname);  
    printT "$consulta\n";  
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    ($id)=$sth->fetchrow_array();# || die "No existe la categoria '$name'\n";
    
    finSub($Sub);
    return $id;
}


