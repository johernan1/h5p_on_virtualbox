#!/usr/bin/perl
#


use Time::HiRes qw(gettimeofday);

print "Incluyendo fichero: auxi\n";


sub pausa{
    print "$_[0] (intro)";
    my $c=<STDIN>;
}

my $tab=0;
my $inctab=4;
my $Tab="";

sub seccion{
    my ($l1,$l2);
    my $ll=79;
    $l1=length($_[0]);
    $l2=($ll-$tab-$l1)/2; 
    #$l2=8; 
    $l1=$Tab . "_" x $l2;
    $l1=$l1.$_[0];
    $l2="_" x ($ll-length($l1));
    "$l1$l2\n";
}

sub iniSub{
	print "\n";
	print seccion("");
	print seccion("Ini: $_[0]");
	print "\n";

	$tab=$tab+$inctab;
	$Tab=" " x $tab;
}

sub finSub{
	$tab=$tab-$inctab;
	$Tab=" " x $tab;
	print "\n";
	print seccion("Fin: $_[0]");
	print seccion("");
	print "\n";
}

sub printT{
    print $Tab,$_[0];
}	

sub _Pausa{
    my $nl=24;
    my $n1=$#_+1;
    my $n2=sprintf "%0.0f", ($nl-$n1)/2; 
    $n1=$nl-$n2-$n1; 
    
    for ($i=1;$i<=$n1;$i++) { print seccion("")}
    for ($i=0;$i<=$#_;$i++) { print seccion ("$_[$i]")};
    for ($i=1;$i<=$n2;$i++) { print seccion("")}
    #pausa();
}


sub Pausa{
    _Pausa(@_);
    pausa();
}


      #########################################################################
sub print_r{
    print "$_[0]"," "x(80-length($_[0]))."\r";
}
      #########################################################################
sub Seccion{
    my ($l1,$l2);
    $l1=length($_[0]);
    $l2=(80 -$l1)/2; 
    $l1= "_" x $l2;
    $l1=$l1.$_[0];
    $l2="_" x (80-length($l1));
    "$l1$l2\n";
}
      #########################################################################
sub titulo{
    "_" x 80 ."\n".
    seccion ($_[0]).
    "_" x 80 . "\n";
}
      #########################################################################
sub subtitulo{
    seccion ($_[0]).
    "_" x 80 .  "\n";
}

      #########################################################################
sub restore{
	#$consulta1="source $_[0];";
	#printT "$consulta1\n";	
	#$dbh->do($consulta1)or die $dbh->errstr;
   
 	_Pausa("Restaurando base de datos $_[0]","tarda unos segundos");
   	my $user="root";
   	my $password="platero";
	my $mysqlexe="\"C:\\Documents and Settings\\etsam\\Escritorio\\moodle\\server\\mysql\\bin\\mysql.exe\""; 
	my $mysystem="$mysqlexe --user=$user --password=$password < $_[0]";
	#print $mysystem;
	system($mysystem);
}

