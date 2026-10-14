#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_course_modules_Insert\n";

sub mdl_course_modules_Insert{
    my $Sub="mdl_course_modules_Insert";
    my $sortname=shift;
    my $section=shift;
    my $instance=shift;
    my $groupingid=shift;
    my $module = shift || 'quiz';
    iniSub($Sub);
    if (is_mdl_release_le(2)) {
	$id=mdl_course_modules_Insert_v2($sortname,$section,$instance,$groupingid)
    }
    elsif (is_mdl_release_ge_or_die(3)) {
	$id=mdl_course_modules_Insert_v3($sortname,$section,$instance,$groupingid, $module)
    };
    finSub($Sub);
    return $id
}

sub mdl_course_modules_Insert_v3{
    my $Sub="mdl_course_modules_Insert_v3";
    my $sortname=shift;
    my $section=shift;
    my $instance=shift;
    my $groupingid=shift;
    my $modulename = shift || 'quiz';
    iniSub($Sub);
    my $course=mdl_course_Id($shortname);
    #my $module=mdl_modules_Id("quiz");
    $module=mdl_modules_Id($modulename);
    my $idsection=mdl_course_sections_Id($course, $section);
    

    ###########################################################################
    
    my $rstGrp='{"type":"grouping","id":'.$groupingid.'}';
    $rstGrade='{"op":"&","c":['.$rstGrp.',{"op":"&","c":['.$RstGrade.
	    ']}],"showc":[false,true]}'; 
    $consulta="insert into mdl_course_modules (course,module,section,instance, groupingid,visible,showdescription, availability) 
               VALUES ($course,$module,$idsection,$instance,$groupingid,
		       1,1,'$rstGrade')";
    
    printT "$consulta\n"; 
    
    $dbh->do($consulta)||die "$consulta";
    ###########################################################################
    $consulta="delete from mdl_course_modules where course=$course and module=$module and instance not in (select id from mdl_$modulename)";
    printT "$consulta\n";
    
    $dbh->do($consulta)||die "$consulta";
    ###########################################################################
    
    $id=last_insert_Id("mdl_course_modules"); 
    printT("id = $id");
    ###########################################################################

    finSub($Sub);
    return $id
}

sub mdl_course_modules_Insert_v2{
    my $Sub="mdl_course_modules_Insert_v2";
    my $sortname=shift;
    my $section=shift;
    my $instance=shift;
    my $groupingid=shift;
    iniSub($Sub);
    my $course=mdl_course_Id($shortname);
    my $module=mdl_modules_Id("quiz");
    my $idsection=mdl_course_sections_Id($course, $section);
    
    ###########################################################################
    
    $consulta="insert into mdl_course_modules (course,module,section,instance, groupingid,groupmembersonly,visible,showdescription) 
               VALUES ($course,$module,$idsection,$instance,$groupingid,1,1,1)";  
    printT "$consulta\n"; 
    
    $dbh->do($consulta)||die "$consulta";    
    ###########################################################################
    $consulta="delete from mdl_course_modules where course=$course and module=$module and instance not in (select id from mdl_quiz)";
    printT "$consulta\n";
    
    $dbh->do($consulta)||die "$consulta";
    ###########################################################################
    
    $id=last_insert_Id();
    ###########################################################################
    #### moodle 2.2
    #### Se actualiza la columna modinfo de mdl_course
    
    ($n_mdl_course_modules)=$dbh->selectrow_array("select count(id) from mdl_course_modules where course=$mdl_curso;");
    $consulta_mdl_course="UPDATE mdl_course SET modinfo = 'a:$n_mdl_course_modules:{}'where id=$course;";
    $dbh->do($consulta_mdl_course) || die "$consulta_mdl_course\n";  

    finSub($Sub);
    return $id
}
