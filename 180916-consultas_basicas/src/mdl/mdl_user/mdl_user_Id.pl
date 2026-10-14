#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_user_Id\n";

sub mdl_user_Id{
    my $username=shift;
    my $Sub="mdl_user_Id";
    iniSub($Sub);
    
    
    my $consulta="select id from mdl_user where username='$username'";  
    printT "$consulta\n";  
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    ($id)=$sth->fetchrow_array();  
    
    
    finSub($Sub);
    return ($id);
}
