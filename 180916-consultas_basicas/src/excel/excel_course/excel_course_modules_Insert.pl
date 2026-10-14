#!/usr/bin/perl
#

print "Incluyendo fichero: excel_course_modules_Insert\n";

sub excel_course_modules_Insert{
    my $Sub="excel_course_modules_Insert";
    my $excel_course_modules=shift;
    my $section=shift;
    my $instance=shift;
    my $groupingid=shift;
    iniSub($Sub);
    

    my $consulta="delete from $excel_course_modules where instance='".$instance."' and section='".$section."'";  
    printT "$consulta\n";      
    $dbh_excel->do($consulta) || die "$consulta";

    ########################################################################### 
    my $id=excel_last_insert_Id($excel_course_modules);
    $id++;

    $consulta="insert into $excel_course_modules (id,section,instance, groupingid) 
               VALUES ($id,$section,'$instance','$groupingid')";  
    printT "$consulta\n"; 
    
    $dbh_excel->do($consulta)||die "$consulta";    
    ###########################################################################

    
    #$id=last_insert_Id();
    finSub($Sub);
    return $id
}
