#!/usr/bin/perl
#

print "Incluyendo fichero: excel_\n";

sub create_tables{
    my $Sub="create_tables";
    iniSub($Sub);
    
    @tables=$dbh_excel->tables();

    #$excel_col{$excel_question}='id INTEGER, name TEXT,idcategory TEXT ,
    #               questiontext TEXT, answer REAL, tolerance REAL, image TEXT';
    #create_tables_($excel_question,
    #		   $excel_col{$excel_question});

    $excel_col{$excel_question_categories}='id INTEGER, name TEXT, 
                   parent TEXT';
    create_tables_($excel_question_categories,
		   $excel_col{$excel_question_categories});
    $excel_col{$excel_quiz}='id INTEGER, name TEXT, intro TEXT';
    create_tables_($excel_quiz,
		   $excel_col{$excel_quiz});

    $excel_col{$excel_quiz_question_instances}='id INTEGER, quiz TEXT, 
                   question TEXT, category TEXT, grade REAL';
    create_tables_($excel_quiz_question_instances,
		   $excel_col{$excel_quiz_question_instances});

    $excel_col{$excel_course_modules}='id INTEGER, instance TEXT, 
                   section INTEGER, groupingid TEXT';
    create_tables_($excel_course_modules,
		   $excel_col{$excel_course_modules});

    $excel_col{$excel_groupings_groups}='id INTEGER, grouping TEXT, 
                   group TEXT';
    create_tables_($excel_groupings_groups,
		   $excel_col{$excel_groupings_groups});
    finSub($Sub);
}

sub create_tables_{
    my $Sub="create_tables-";
    iniSub("$Sub");
    ($table,$col)=@_;
    $col =~ s/\n[ \t]*/ /g;
    printT "se crea la tabla '$table':\n";
    printT "    $col\n";
    # Si la variable $table no esta definida se finaliza la funcion
    if (not defined($table)) {return};
    
    my $n=0, $nmax=1;
    printT "se comprueba si esta incluida en @"."tables: @tables\n";
    while (grep {/$table/} @tables ) {
	printT "   $table esta en @tables";
	$excel_col{$table."_"}=$col;
	$table=$table."_";
        $n++;
    }
    printT "si lo esta se borra\n"; 
    if ($n>$nmax) {
	chop $table;
	my $sth = $dbh_excel->prepare("DROP  TABLE $table")
        or die "Cannot prepare: " . $dbh->errstr();
	$sth->execute() or die "No se puede borrar la tabla: ".$sth->errstr();	
    }
    print "-----OJO OJO OJO-----------------------------------------------\n";
    print "Si en la siguiente linea se produce un error Out of memory debe\n";
    print "sustituirse Excel.pm (BDB::Excel) por el New_Excel.Pm \n";
    print "incluido junto a src\n";
    print "-----OJO OJO OJO-----------------------------------------------\n";	

    my $consulta="CREATE  TABLE $table ($col)";
    printT "se añade la hoja de excel:\n";
    printT "$consulta\n";
    my $sth = $dbh_excel->prepare($consulta)
        or die "Cannot prepare: " . $dbh->errstr();
    $sth->execute() or die "No se puede crear la tabla: '$table'" . $sth->errstr();
    $sth->finish();
    $_[0]=$table;
    printT "Se ha incluido en '$excel'\n";
    printT "la tabla '$table'\n";
    pausa();
    finSub($Sub);
}


sub ini_excel_question_categories {
    my $Sub="ini_excel_question_categories";
    iniSub("$Sub");
    
    printT "se añade la categoría '$shortname'";
    excel_question_categories_Insert($excel_question_categories,
				     "$shortname",'');
    printT "se añade la categoría '$ejercicio/$shortname'";
    excel_question_categories_Insert($excel_question_categories,
				     "$ejercicio","$shortname");
    printT "Se han añadido '$shortname'\n";
    printT "               '$ejercicio/$shortname'\n";
    printT "a la tabla $excel_question_categories";
    pausa();
    finSub($Sub);
}

sub excel_ {
    my $Sub="excel_";
    $excel_question=shift;
    iniSub($Sub);
    create_tables();
    ini_excel_question_categories() if (defined($excel_question_categories));

    #### excel_consulta, prepare_excel_consulta definidas en
    #### excel_mdl_question_answers_numerical_Insert 
    prepare_excel_consulta();

    my $i=0;
    while ($consulta=excel_consulta($excel_question)) {
	$i++;

	my $sth=$dbh_excel->prepare($consulta);
	$sth->execute();
	while (my ($id,$name0,$name,$category,
		   $questiontext,$answer,$tolerance)=$sth->fetchrow_array()) 
	{
	    #### por 'quiz' debe entenderse cada conjunto de columnas
            #### name, categoryid,questiontext,... de la hoja $excel_question
	    #1. No esta definida la columna 'name' para el 'quiz'
	    $name="$name0$post" if ($name eq $name0);
	    #2. Esta definada la columna 'name' pero el de la celda es ''
	    $name="$name0$post" if ($name eq '' );
	    #3. No esta definida la columna 'name' para ningun quiz
	    $name="$shortname:$ejercicio:$i:pregunta $id" if ($name0 eq '');
	    $category="$ejercicio:$i" if ($category eq '');

	    excel_question_categories_Insert($excel_question_categories,
					     "$category","$ejercicio") 
		if (defined($excel_question_categories));
	    
	    excel_quiz_question_instances_Insert($excel_quiz_question_instances,
						 "$shortname:$ejercicio:$i",
						 "$name","$category",1)
		if (defined($excel_quiz_question_instances));
	}
	excel_quiz_Insert($excel_quiz,
			  "$shortname:$ejercicio:$i",
			  $excel_quiz_intro)
	    if (defined($excel_quiz));
	excel_course_modules_Insert($excel_course_modules,
				    $semana,
				    "$shortname:$ejercicio:$i",
				    "grupo:$ejercicio:$i")
	    if (defined($excel_course_modules));
	excel_groupings_groups_Insert($excel_groupings_groups,
				      "grupo:$ejercicio:$i",
				      "grupo:$ejercicio:$i")
	    if (defined($excel_groupings_groups));
    }
    printT("OKkkk");
    $dbh_excel->func('save');
    finSub($Sub);
}


