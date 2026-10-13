#!/usr/bin/perl
use strict;
#use warnings;

print ("leido margenessvg\n");
sub cambiaAnchosvg {
    my $file=shift;
    my $ofile=shift;
    my $nuevoancho=shift;
    print ("----inicio cambiaAnchosvf\n");

    my $aux="grep width= $file| sed 's/.*width=//'| sed 's/\"//g'";
    my $anchoOriginal=qx($aux);
    my $margenes=($nuevoancho-$anchoOriginal)/2;
    
    margenessvg($file,$ofile,$margenes,$margenes);
    print ("----fin cambiaAnchosvf\n");
}
sub margenessvg {
    print ("----inicio margenessvg\n");
    
    my $file=shift;
    
    my $ofile=shift;
    my $lM=shift;
    my $rM=shift;

    print ("    Funcionará si el fichero svg esta separado en lineas".
	" y si esta definido una linea:  transform=\"scale() translate(,)\n");
    print ("    Solo funciona despues de inkscape fileout  --export-plain-svg=xxx.svg --export-area-drawing ...\n");
	
    open(I_FILE, "$file")
	or die "Could not open input file '$file' $!";
    open(O_FILE,  "> $ofile")
	or die "Could not open output file '$ofile' $!";
    
    my $aux="grep width= $file| sed 's/.*width=//'| sed 's/\"//g'";
    #print "$aux\n";
    my $anchoOriginal=qx($aux);
   


    while (my $row = <I_FILE>) {
        if ($row=~/ width="/) {
	    my $newval=$anchoOriginal+$lM+$rM;
	    # Se sustituye el contenido entre las comillas.
	    # (ojo, que las comillas despistan un poco)
	    $row=~s/".*"/"$newval"/;
	}
	if ($row=~/ transform="/) {
	    my $scale=$row;
	    #print "$row\n";
	    $scale=~s/.*scale\(//;
	    $scale=~s/\).*//;
	    #print "scale=$scale\n";
	    my $translateX=$row;
	    $translateX=~s/.*translate\(//;
	    $translateX=~s/,.*//;
	    #print "translateX=$translateX\n";
	    $translateX=$translateX+$lM/$scale;
	    #print "row=$row\n";
	    $row=~s/translate\(.*,/translate($translateX,/;
	    #print "row=$row\n";
	}
	
	print O_FILE $row;
    }
    close (I_FILE);
    close (O_FILE);
    
    print ("----fin margenessvg (if=$file, of=$ofile)\n");
}
