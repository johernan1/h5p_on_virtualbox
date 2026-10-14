#!/usr/bin/perl
#

print "Incluyendo fichero: excel_question_Insert\n";

sub excel_question_Insert{
    my $excel_question= shift;
    my $name= shift;
    my $category= shift;
    my $questiontext= shift;
    my $answer= shift;
    my $tolerance= shift;
    my $image= shift;
    my $Sub="excel_question_Insert";
    iniSub($Sub);

    my $id=excel_last_insert_Id($excel_question);
    $id++;

    ### Es necesario usar 'placeholders' pare evitar bug con '--' (comenta SQL)
    ### del paquete SQL::Statement
    my $consulta="insert into $excel_question (id,name,idcategory,questiontext,answer,tolerance,image) VALUES (?,?,?,?,?,?,?)";  
    printT "$consulta, default, $id,$name,$category,$questiontext,$answer,$tolerance,$image\n";
  
    $dbh_excel->do($consulta, default, $id,$name,$category,$questiontext,$answer,$tolerance,$image)||die "$consulta";
        
    finSub($Sub);
}
