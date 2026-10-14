#!/usr/bin/perl
#

print "Incluyendo fichero: excel_question_categories_Id\n";

sub excel_question_categories_Id{
    my $excel_question_categories=shift;
    my $name=shift;
    my $Sub="excel_question_categories_Id";
    iniSub($Sub);
    
    my $consulta="select id from $excel_question_categories where name='$name'";  
    printT "$consulta\n";  
    
    my $sth=$dbh_excel->prepare($consulta);
    $sth->execute();
    ($id)=$sth->fetchrow_array();# || die "No existe la categoria '$name'\n";
    
    finSub($Sub);
    return $id;
}


