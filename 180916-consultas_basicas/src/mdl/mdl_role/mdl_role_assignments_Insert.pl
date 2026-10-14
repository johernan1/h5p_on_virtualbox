#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_role_assignments_Insert\n";


sub mdl_role_assignments_Insert{
    
    my $roleid=shift;
    my $userid=shift;
    my $contextid=shift; ### Ver tabla mdl_role_capabilities

    my $Sub="mdl_role_assignments_Insert";
    iniSub($Sub);
    
    
    $consulta="insert into mdl_role_assignments (roleid,contextid,userid) values('$roleid','$contextid','$userid')";
    printT "$consulta\n";	
    $dbh->do($consulta) || warn("El error anterior ocurre si se intenta asignar por segunda vez el mismo role a un usuario\n");
;
    finSub($Sub);
}
