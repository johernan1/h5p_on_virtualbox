#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_user\n";

sub mdl_user{
    my $Sub="mdl_user";
    iniSub($Sub);

    my $consulta="select username,firstname,lastname,password from mdl_user";  
    printT "$consulta\n"; 
    
    my $sth=$dbh->prepare($consulta);
    $sth->execute();
    while (@row=$sth->fetchrow_array()) {
	printT "username=$row[0], firstname=$row[1], lastname=$row[2], password=$row[3]\n";      
    }
    
    
    finSub($Sub);
}
