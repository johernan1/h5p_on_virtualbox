#!/usr/bin/perl
#

print "Incluyendo fichero: excel_quiz_Insert\n";

sub excel_quiz_Insert{
    my $Sub="excel_quiz_Insert";
    my $excel_quiz=shift;
    my $name=shift;
    my $intro=shift;

    iniSub($Sub);
    
    ### Probablemente no funcione correctamente
    ### Ver comentario posterior sobre 'placeholders'
    my $consulta="delete from $excel_quiz where name='".$name."' and intro='".$intro."'";  
    printT "$consulta\n";      
    $dbh_excel->do($consulta) || die "$consulta";

    ########################################################################### 
    my $id=excel_last_insert_Id($excel_quiz);
    $id++;

    ### Es necesario usar 'placeholders' pare evitar bug con '--' (comenta SQL)
    ### del paquete SQL::Statement
    $consulta="insert into $excel_quiz (id,name,intro) VALUES (?,?,?)";   
    printT "$consulta,undef,$id,$name,$intro\n"; 
    
    $dbh_excel->do($consulta,undef,$id,$name,$intro) || die "$consulta\n"; 

    ; 
    finSub($Sub);
    return($id);
}
