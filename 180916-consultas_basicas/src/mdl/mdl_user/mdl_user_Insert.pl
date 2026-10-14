#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_user_Insert\n";


sub mdl_user_Insert{
    
    my $username=shift;
    my $password='e0f352008c0d93aca9c2580d92c30a23';
    my $Sub="mdl_user_Insert";
    iniSub($Sub);
    
    
    $id=mdl_user_Id($username);
    if (!defined($id)) {
	printT "Se añade el usuario $username\n";
	$consulta1="insert into mdl_user (username,firstname,lastname,password,mnethostid,confirmed,email,city,country) values('$username','$username','$username','$password',1,1,'$username\@upm.es','madrid','ES')";
	printT "$consulta1\n";	
	$dbh->do($consulta1);
	$id=mdl_user_Id($username);
    }
    finSub($Sub);
    return $id;   
}
