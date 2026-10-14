#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_groups_members_Insert\n";

sub mdl_groups_members_Insert{
    my $alumno=shift;
    my $grupo=shift;
    my $Sub="mdl_groups_members_Insert";
    iniSub($Sub);
    
    $consulta="delete from mdl_groups_members where groupid not in (select id from mdl_groups)";
    printT "$consulta\n";  
    $dbh->do("$consulta") || die "$Sub: $consulta";

    $consulta="insert into mdl_groups_members (groupid,userid)
           (select mdl_groups.id,  mdl_user.id 
                   from mdl_groups, mdl_user   
                   where mdl_groups.name='$grupo' and mdl_user.username='$alumno' )"; 

    printT "$consulta\n";  
    $dbh->do("$consulta") || die "$Sub: $consulta";
    
 
    
    finSub($Sub);
}
