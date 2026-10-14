#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_question_Insert\n";

sub mdl_question_Insert{
    my $name=shift;
    my $category=shift;
    my $questiontext=shift;
    my $qtype=shift;
    $qtype="numerical" if ($qtype eq '');
    my $Sub="mdl_question_Insert ($qtype)";
    iniSub($Sub);
           
    mdl_question_Delete($name,$category);
    
###    my $consulta="insert into mdl_question (name,category,questiontext,generalfeedback,qtype,questiontextformat,stamp) VALUES ('$name',$id, '$questiontext','\"','numerical',1,'".stamp()."+$test g$n p$nq')";
    my $consulta="insert into mdl_question (name,category,questiontext,qtype,stamp,generalfeedback) VALUES ('$name',$category, '$questiontext','$qtype','".stamp()."','\"')";  
    printT "$consulta\n";  

    $dbh->do($consulta)||die "$consulta";
        
    $id=last_insert_Id("mdl_question");
    finSub($Sub);
    return $id
}
