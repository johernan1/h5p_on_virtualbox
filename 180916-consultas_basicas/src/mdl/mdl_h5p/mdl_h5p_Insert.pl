#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_h5p_Insert\n";

sub mdl_h5p_Insert{
    my $Sub="mdl_h5p_Insert";
    my $name=shift;
    my $intro=shift;
    my $course=shift;
    my $grade=10;
    my $review22=69904;
    iniSub($Sub);

    
    my $consulta="delete from mdl_h5pactivity where name='".$name."' and intro='".$intro."'and course='".$course."'";  
    printT "$consulta\n";  
    
    $dbh->do($consulta) || die "$consulta";
    my $dirimage=$exceldir;
    $ficheroH5P=$excel;
    # El fichero de excel tiene el formato H5P*xls, se 'renombra'
    $ficheroH5P=~s/.*H5P/h5p/;
    $ficheroH5P=~s/.xls/.h5p/;
    Pausa("dirimage=$dirimage, excel=$excel, h5p=$ficheroH5P");
#    		copy ("$dirimage/$Answerss[$iAnswers]",
#		      "$dirimage/$ficheroOfuscado") or die "Copy failed: $!.\n\n ¿Estan los ficheros gif en un directorio llamado drag_drop\n\n";;
#		pausa("$id");
#		
    #
                Pausa("mdl_h5p_image_Insert($name,$ficheroH5P,
		      mod_h5pactivity, images)");

	    $consulta="insert into mdl_h5pactivity (name,intro,course,timecreated,timemodified,grade) VALUES ('$name','$intro',$course,1610303108,1610303108,10)";
    $dbh->do($consulta) || die "$consulta\n"; 
    Pausa($consulta);
    
    mdl_context_Insert(last_insert_Id("mdl_course_modules")+1,$course);
	       
	    
    mdl_h5p_image_Insert($name,"$ficheroH5P",
			 "mod_h5pactivity", 'package');
}

sub KO{
    ###########################################################################
    # Las funciones:
    #      prepare_excel_consulta() y
    #      excel_consulta() 
    # estan definidas en: excel_mdl_question_answers_numerical_Insert 
    prepare_excel_consulta(); 
    $i=0;
    my $multichoicegrifos;
    printT "excel_question: $excel_question\n";
    while ($consulta=excel_consulta($excel_question)) {
	$i++;
	
	
	printT "consulta=$consulta\n";
	my $sth=$dbh_excel->prepare($consulta);
	$sth->execute();

	#mdl_context_Insert(,$course);
	while ((my   $id,$name0,$name__,$category,$questiontext,$answer,
		$tolerance,$image,$diagGeom, $diagEsf, 
		$dragdrop, $drop, 
		$multichoicegrifos_, $h5p)=$sth->fetchrow_array()){
	    printT "name=$name\n";
	    printT "\nhola: multichoicegrifos_: $multichoicegrifos_\n"; 
	    #if ($name eq $name0) {$name="$name$post";}
	    $H5P=$h5p; #H5P no es local
	    $multichoicegrifos=$multichoicegrifos_;
	    printT "\nhola: multichoicegrifos: $multichoicegrifos\n"; 
	    #$NAME=$name;
	    #exit(2);
	
	    
	    
    # Chapucilla para incluir sólo la última
	    printT "------------------$multichoicegrifos\n"; 
	    #$consulta="insert into mdl_h5pactivity (name,intro,course,json_content,main_library_id, filtered) VALUES ('$name','$intro',$course, '$H5P', 4, '$H5P')";
	    $consulta="insert into mdl_h5pactivity (name,intro,course,timecreated,timemodified,grade) VALUES ('$name','$intro',$course,1,1,10)";
	    $dbh->do($consulta) || die "$consulta\n"; 
	    Pausa($consulta);

	    #$h5pid=mdl_h5p_Id($name,$course);
	    
	    mdl_context_Insert(last_insert_Id("mdl_course_modules")+1,$course);
	       
	    
	    print $multichoicegrifos;
	    ###################################################
	    # se 'ofuscan' e incluyen las figuras
	    my $nAnswers = $multichoicegrifos =~ tr/;//;
	    $multichoicegrifos=~s/ //g;
	    my @Answerss = split /;/, $multichoicegrifos;
	    $nAnswers++;
	    $answers='';
	    print $multichoicegrifos; 
	    print "xxxxxx:$multichoicegrifos\n";
	    print "Answerss=@Answerss\n";
    
	    for($iAnswers=0;$iAnswers<$nAnswers;$iAnswers++) {
		pausa("EMPIEZA EL LIO=$multichoicegrifos....$Answerss[$iAnswers]");
		#---------------------------------------------------------------------
		# Se cambia elnombre del fichero para "ofuscar" la pregunta
		$ficheroOfuscado=last_insert_Id("mdl_files");
		
		#$questiontext="<p> <img style=\"vertical-align: middle; display: block; margin-left: auto; margin-right: auto;\" hspace=\"0\" border=\"0\"  width=50%\" vspace=\"0\" src=\"\@\@PLUGINFILE\@\@/$Answerss[$iAnswers]\" /><br /><p/> ";
		#$questiontext="<p> <img style=\"vertical-align: middle;  width=50%\" src=\"\@\@PLUGINFILE\@\@/$Answerss[$iAnswers]\" /><br /><p/> ";
		
		#$questiontext="<p> <img style=\"vertical-align: middle;  width=50%\" src=\"\@\@PLUGINFILE\@\@/$ficheroOfuscado\" /><br /><p/> ";
		#if ($iAnswers+1 eq $choice) { 
		#    $answer=mdl_question_answers_Insert($question,
		#					$questiontext,1);
		#} else { 
		#    $answer=mdl_question_answers_Insert($question,
		#					$questiontext,0);
		#}
		$answer=$iAnswers;
		#my $consulta = "update mdl_question_answers set answerformat=1 where id=$answer";
		#$dbh->do($consulta)||die "$consulta";
		
		# De este modo no se "ofusca" la pregunta
		# mdl_question_image_Insert($answer,$Answerss[$iAnswers],'question', 'answer');
		#---------------------------------------------------------------------
		# Se cambia elnombre del fichero para "ofuscar" la pregunta
		my $dirimage=$exceldir;
		pausa("$answer, $Answerss[$iAnswers]");
		pausa();
		$ficheroOfuscado=$Answerss[$iAnswers];
		$ficheroOfuscado=~s/.*\///g;
		
		pausa($ficheroOfuscado);
		pausa("$iAnswers: $dirimage/$Answerss[$iAnswers]->$dirimage/$id");
		copy ("$dirimage/$Answerss[$iAnswers]",
		      "$dirimage/$ficheroOfuscado") or die "Copy failed: $!.\n\n ¿Estan los ficheros gif en un directorio llamado drag_drop\n\n";;
		pausa("$id");
		
		
		mdl_h5p_image_Insert($name,"$ficheroOfuscado",
				     "mod_h5pactivity", 'images');
 #while(siono("contextid=$contextid, nh5p=$nh5p.  n para continuar", 'si','n') eq 'si'){};
		unlink  ("$dirimage/$ficheroOfuscado") or die "Rm failed failed: $!";;
		pausa();
		
		$answers="$answer,$answers";
	    }
	    
	    ##################################################
	    
	    #$id=last_insert_Id();  
	    $id=mdl_question_categories_Id($shortname,$name);
	}
    }
    finSub($Sub);
    return($id);
}
