#!/usr/bin/perl
#

print "Incluyendo fichero: excel_last_insert_Id\n";

sub excel_last_insert_Id{
    $table=shift;

    $consulta= "select max(id) from $table";
    my $sth = $dbh_excel->prepare($consulta);
    $sth->execute();
    my ($id)=$sth->fetchrow_array() || (0);
    return $id;
}
