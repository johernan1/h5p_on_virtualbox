#!/usr/bin/perl
#
    use File::Copy qw(copy);
     
    
print "Incluyendo fichero: mdl_question_drags_Insert\n";

sub mdl_question_drags_Insert{
    my $question=shift;
    my $n=shift;
    my $file=shift;
    #if($fraction eq '') {$fraction=1;};

    my $Sub="mdl_question_drags_Insert";
    iniSub($Sub);
 
   
    Pausa("Pendiente",
	  "mdl_question_drags_Delete();");
#    mdl_question_answers_Delete();
    
    $n++;
    my $consulta="insert into mdl_qtype_ddimageortext_drags (questionid,no,draggroup, label) VALUES ($question,$n, 1, ' ')";  
    printT ("$consulta\n");  
    
    $dbh->do($consulta)||die "$consulta";
    $id=last_insert_Id("mdl_qtype_ddimageortext_drags");
    #-------------------------------------------------------------------------
    # Se cambia elnombre del fichero para "ofuscar" la pregunta
    my $dirimage=$exceldir;
    #printT ("copy-------------------------$file, $id\n");
    my $extension=$file;
    $extension=~s/.*\.//;
    pausaT ("210402: extension del fichero de imagen: $extension\n");
    copy ("$dirimage/$file", "$dirimage/$id.$extension") or
	die "Copy failed: $!";;
    #pausa  ("copy-------------------------$file, $id\n");
    #mdl_question_image_Insert($id,$file,'qtype_ddimageortext','dragimage') if ($image ne '');
    
    mdl_question_image_Insert($id,"$id.$extension",'qtype_ddimageortext','dragimage') if ($image ne '');
    #printT ("se borra------------------------- $id\n");
    unlink  ("$dirimage/$id.$extension") or die "Rm failed failed: $!";;
    #pausa  ("se borra------------------------- $id\n");

    $id=last_insert_Id("mdl_files");
    finSub($Sub);
    return $id
}
