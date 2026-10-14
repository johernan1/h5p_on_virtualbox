#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_context_Insert\n";

sub mdl_context_Insert{
    my $Sub="mdl_context_Insert";
    my $instanceid=shift;
    my $course=shift;
    iniSub($Sub);
    
    #$consulta="insert into mdl_context (instanceid,contextlevel,course,json_content,main_library_id, filtered) VALUES ('$instanceid','$intro',$course, '$H5P', 4, '$H5P')";
    #Pausa("falta ajustar main_library_id");
    #Pausa($consulta);

    ($contextid)=$dbh->selectrow_array("select last_value from mdl_context_id_seq");
    $contextid+=1;
    $consulta= "select mdl_context.path, mdl_context.depth from mdl_context where instanceid=$course and contextlevel=50";
    ($mdl_context_path,$mdl_context_depth)=$dbh->selectrow_array($consulta);
    $mdl_context_depth+=1;
    
    $consulta_mdl_context= "insert into mdl_context (contextlevel,instanceid,path,depth) VALUES (70,$instanceid,'$mdl_context_path/$contextid',$mdl_context_depth)";
    
    $dbh->do($consulta) || die "$consulta\n"; 
    $dbh->do($consulta_mdl_context) || die "$consulta\n"; 
    finSub($Sub);
    return($id);
}
