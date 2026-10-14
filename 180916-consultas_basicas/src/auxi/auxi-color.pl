#!/usr/bin/perl
#

#use Win32::Console::ANSI;
use Term::ANSIColor;

use Time::HiRes qw(gettimeofday);
use File::Copy;

print "Incluyendo fichero: auxi\n";


sub pausa{
    print "$_[0] (intro)";
    my $c=<STDIN>;
}

my $tab=0;
my $inctab=4;
my $Tab="";
my $color=0;

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
	if ($tab==0) {
		$aux=31+$color % 6;
		print "\e[1;$aux"."m";
		$color++;
	}
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
	if ($tab==0) {
		print "\e[0m";
	}
}

sub printT{
    print $Tab,$_[0];
}	

sub pausaT{
    printT "$_[0] (intro)";
    my $c=<STDIN>;
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
   	my $user="moodle";
   	my $password="moodle";
	my $mysystem="dropdb --user $user  moodle;".
	    "createdb --user $user moodle;".
	    "psql --user $user < $_[0]";
	print $mysystem;
	system($mysystem);

}

      #########################################################################
sub fichero {
    $por_defecto=shift;
    my $aux=shift;
    my $noexiste="\nNo existe $fichero";
    print "\e[1;31mFichero de datos (intro=$por_defecto)$aux\n\e[0m";
    $fichero=<stdin>; chomp $fichero; $fichero=$por_defecto if ($fichero eq '');
    $fichero=fichero($por_defecto, $noexiste) if not (-e $fichero);
    return $fichero;
}
      #########################################################################

sub tmpfichero {
    my $fichero=shift;
    my $copia=$fichero;
    $copia=~s@.*[/\\]@@g;
    if ($ENV{'TMP'} eq '') { #Linux
	$copia="/tmp/copia_$copia" if $aux eq '';
    }
    else { #Msdos
	$copia="$ENV{'TMP'}/copia_$copia" if $aux eq '';
    }
    if ($aux eq '') {
	copy("$fichero","$copia") or die "error al copiar: $fichero->$copia";
	printT "se manipula la copia $copia\n";
    }
    return "$copia"
}
      #########################################################################


sub siono {
    $texto=shift;
    $por_defecto=shift;
    $no_por_defecto=shift;
    print "\e[1;31m$texto (intro=$por_defecto)\n\e[0m";
    $siono=lc(<stdin>); chomp $siono; $siono=$por_defecto if ($siono eq '');
    
    if (($siono ne $por_defecto) and ($siono ne $no_por_defecto)) {
	$siono=siono($texto,$por_defecto,$no_por_defecto)}
	
    return $siono
}

sub siosi {
    $texto=shift;
    $por_defecto=shift;
    $no_por_defecto=shift;
    while(siono($texto,$por_defecto,$no_por_defecto) eq 'no') {};
    return $pordefecto;
}

sub stamp{
    my $Sub="stamp";
    iniSub($Sub);
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst);
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =  gmtime(time);
    $year=$year-100;
    $mon=sprintf("%02d",$mon+1);
    $hour=sprintf("%02d",$hour);
    $min=sprintf("%02d",$min);
    $sec=sprintf("%02d",$sec);
    
    finSub($Sub);
    return "localhost+$year$mon$mday$hour$min$sec";
}
