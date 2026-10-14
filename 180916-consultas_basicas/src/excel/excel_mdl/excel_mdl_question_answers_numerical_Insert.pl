#!/usr/bin/perl
#

print "Incluyendo fichero: excel_mdl_question_answers_numerical_Insert\n";

sub excel_mdl_question_answers_numerical_Insert {
    my $Sub="excel_mdl_question_answers_numerical_Insert";
    $excel_question=shift;
    iniSub($Sub);
    
    pausa ("200126  $Sub->excel_questions=$excel_question");
    prepare_excel_consulta();
    my $i=0;
    while ($consulta=excel_consulta($excel_question)) {
	$i++;

        pausa ("200126  $Sub->consulta=$consulta");

	my $sth=$dbh_excel->prepare($consulta);
	$sth->execute();
	while ((my $id,$name0,$name,$category,$questiontext,$answer,
		   $tolerance,$image,$diagGeom, $diagEsf, 
		   $dragdrop, $drop, 
		   $multichoicegrifos)=$sth->fetchrow_array()){
	   
	   
	    #if ($name eq $name0) {$name="$name$post";}

	    #### por 'quiz' debe entenderse cada conjunto de columnas
            #### name, categoryid,questiontext,... de la hoja $excel_question
	    #1. No esta definida la columna 'name' para el 'quiz'
	    $name="$name0$post" if ($name eq $name0);
	    #2. Esta definada la columna 'name' pero el de la celda es ''
	    $name="$name0$post" if ($name eq '' );
	    #3. No esta definida la columna 'name' para ningun quiz
	    $name="$shortname:$ejercicio:$i:pregunta $id" if ($name0 eq '');
	    $category="$ejercicio:$i" if ($category eq '');

            #Se copia a imagen al directorio actual
	    my $dirimage=$exceldir;
            $image_="C$image"; 
            $image_=~s/\//_/g;
	    #Pausa("$image->$image_");
	    #copy ("$dirimage/$image", "$exceldir/$image_") or die "Copy failed: ($dirimage/$image->$exceldir/$image_)!";

 	    my $idcategory=mdl_question_categories_Id($shortname,$category)||
                           mdl_question_categories_Id($shortname,
			      "Default for ".mdl_course_Fullname($shortname))||
                           mdl_question_categories_Id($shortname,
			      "Por defecto en ".mdl_course_Fullname($shortname));
	    if ($image ne '' && $dragdrop eq '') {
		 copy ("$dirimage/$image", "$exceldir/$image_") or die "Copy failed: ($dirimage/$image->$exceldir/$image_)!";
		$questiontext="$moodleTxtQue <img style=\"display: block; margin-left: auto; margin-right: auto;\" hspace=\"0\" border=\"0\"  width=50%\" vspace=\"0\" src=\"\@\@PLUGINFILE\@\@/$image_\" /><br /> $questiontext";
	    }

            if ($diagGeom ne '') {
		$id=mdl_question_answers_diagrams_Insert($name,$idcategory,
							 $questiontext,
							 $answer,$tolerance,
							 $diagGeom,$diagEsf);
	    }
	    elsif ($dragdrop ne '') {
		pausa("-----dyd 200126 questiontext=$questiontext, drop=$drop, dyd=$dragdrop, image_=$image_");
		copy ("$dirimage/$image", "$exceldir/$image_") or die "Copy failed: ($dirimage/$image->$exceldir/$image_)!";
		$id=mdl_question_answers_dragdrop_Insert($name,$idcategory,
							 $image_,$dragdrop,
							 $drop);
	    }
	    elsif ($multichoicegrifos ne '') {
		pausa("-----mc ---questiontext=$questiontext, drop=$drop, multichoicegrifos=$multichoicegrifos");
		$id=mdl_question_answers_multichoicegrifos_Insert($name,$idcategory,
		                                                  $multichoicegrifos,
                                                                  $drop);
	    }
	    else {
		$id=mdl_question_answers_numerical_Insert($name,$idcategory,
							  $questiontext,
							  $answer,$tolerance);
	    }

	    #mdl_question_image_Insert($id,$image,$category) if ($image ne '');
	    mdl_question_image_Insert($id,$image_,'question', 'questiontext') if ($image ne '' && $dragdrop eq '');
            # Se borra la copia del fichero que se ha utilizado
	    if ($image ne '' && $dragdrop eq '') {
		unlink  ("$dirimage/$image_") or die "Rm failed failed: $!";;
	    }
	}
    }
    finSub($Sub);
}


sub prepare_excel_consulta {
    $n_excel_consulta=0;
    my $sth = $dbh_excel->prepare("SELECT * from $excel_question LIMIT 1");
    $sth->execute() || die "\n\nEsta definida la tabla $excel_question?\n\n";
    @names_excel_consulta= @{$sth->{NAME}};
}

sub excel_consulta {
    $excel_question=shift;
    $n_excel_consulta++;
    $new_col_flag=0;
    $post="_".($n_excel_consulta-2)."_";
    if ($n_excel_consulta==1) {$post="";}

#    $name="''";
#    $idcategory="''";

    $id          =excel_col_name("id",$post);
    $name        =excel_col_name("name",$post); 
    $idcategory  =excel_col_name("idcategory",$post); 
 #   $name        =excel_col_name("name",$post) 
 #                                if (grep{/name/} @names_excel_consulta); 
 #   $idcategory  =excel_col_name("idcategory",$post) 
#	                         if (grep{/idcategory/} @names_excel_consulta);
    $questiontext=excel_col_name("questiontext",$post);
    $answer      =excel_col_name("answer",$post);
    $tolerance   =excel_col_name("tolerance",$post);
    $image       =excel_col_name("image",$post);
    $diagGeom    =excel_col_name("diaggeom",$post);
    $diagEsf     =excel_col_name("diagesf",$post);
    $dragdrop    =excel_col_name("dragdrop",$post);
    $drop        =excel_col_name("choice",$post);
    $multichoicegrifos    =excel_col_name("multichoicegrifos",$post);
    $h5p    =excel_col_name("h5p",$post);
 
    if ($new_col_flag>0) {
	my $name0="name"; 
	$name0="''" if ($name eq "''");
	return "select $id, $name0 as name0, $name as name1, $idcategory as idcategory, $questiontext, $answer, $tolerance, $image, $diagGeom, $diagEsf, $dragdrop, $drop, $multichoicegrifos, $h5p  from $excel_question where id is NOT NULL"; 
    }
    
}

sub excel_col_name{
    my $col_name_=shift;
    my $post=shift;
    my $col_name_post="$col_name_$post";

    undef $col_name;
    ($col_name)=grep(/$col_name_post/, @names_excel_consulta);
    if (defined $col_name) {
	$new_col_flag++;
	return $col_name;}
    else {
	return $col_name_ if (grep(/$col_name_/, @names_excel_consulta));
	return "''";}
}
