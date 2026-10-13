#!/usr/bin/perl
#
# 
# perl tex2gif.pl -> dibujos para multichioice
# perl tex2gif.pl dd -> dibujos para drag&drop
use Cwd qw(cwd);
my $dir = cwd;

my ($dd, $dondeestoy)=@ARGV;
#print "dd=$dd, $dondeestoy\n"; exit; 
$PATH="$dir/../src";


print "$PATH\n";
#do "$PATH/moodleDiagram2svg.pl";
do "$PATH/newmoodleDiagram2svg.pl";
do "$PATH/mvsvg.pl";
do "$PATH/margenessvg.pl";
do "$PATH/moodleFig.pl";


$dir = "tex";
system "rm drag_drop/*";
opendir(DIR, "$dir")
	    or die "Could not open dir '$dir' $!";
@FILES = readdir(DIR);

#------------------------------------------------------------------------------
# Figuras
foreach $file (@FILES) {
    if ($file=~/tex/) {
	print "-------------------------------------\n";
	print $file, "\n";
	print "-------------------------------------\n";
        $id=$file;
	$id=~s/.*n//;
        $id=~s/.tex//;
	open(IFILE, "$dir/$file")
	    or die "Could not open file '$file' $!";
	$nmD=0;
	#$hmin300x300=0;
	while (my $row = <IFILE>) {
	    if ($row=~/moodleDiagram/) {
		print "-------------------------------------\n";
		print "190708-Diag: $row, \n";
		print "-------------------------------------\n";
		$nmD++;
		($texto, $topo, $diag)=split /\}\{/, $row;
		print "texto=$texto\n";
		print "topo=$topo\n";
		print "diag=$diag\n";
		#--- Dibujos pequeños ------------------------------------------
		$fileout="drag_drop/$id"."_$nmD.svg";
		$filegif="drag_drop/$id"."_$nmD.gif";
		$ancho=150;
		$alto=150;
		$margenes=2;
		$grosorL=2.5;
	        $escala=moodleDiagram2svg2file($fileout, $topo, $diag, 
				        $ancho, $alto, $margenes, $grosorL
		    );
		# Se crea el gif
		#system "inkscape $fileout -e /tmp/xxx.png; 
		#        convert /tmp/xxx.png $filegif;
                #        #rm $fileout /tmp/xxx.png /tmp/xxx.svg;
		#";
		
                #----Idem para dibujo 'grande'----------------------------------
		
		$fileout="drag_drop/$id"."_$nmD"."_600.svg";
		$filegif="drag_drop/$id"."_$nmD"."_600.gif";
		
		$ancho=450;
		$alto=300;
		$margenes=20;
		$grosorL=5;
	        $escala=moodleDiagram2svg2file($fileout, $topo, $diag, 
				        $ancho, $alto, $margenes, $grosorL
		    );
		print "inkscape $fileout -e /tmp/xxx.png; 
		        convert /tmp/xxx.png $filegif;
		       ";	
		system "inkscape $fileout -e /tmp/xxx.png || 
				inkscape $fileout --export-type=png --export-filename=/tmp/xxx.png; 
				convert /tmp/xxx.png $filegif;
		       ";	
		if ($escala<1) {
		    # Se ajusta el ancho del dibujo.
		    # moodleDiagram2svg2file reduce el ancho del dibujo para
		    # ajustar la altura si es preciso
		    cambiaAnchosvg($fileout, "/tmp/xxx5.svg", $ancho);
		    system ("cp /tmp/xxx5.svg $fileout");
		    #exit;
		    #system ("convert $filegif -background white -gravity center -extent $ancho /tmp/xxx7.gif; cp /tmp/xxx7.gif $filegif"); 
		}
		if ($dd eq "dd") {
		    margenessvg($fileout, "/tmp/xxx6.svg",600-$ancho,0);
		    system ("cp /tmp/xxx6.svg $fileout");
		    #exit;
		    #system ("cp $filegif /tmp/xxx8.gif; convert  /tmp/xxx8.gif  -background white -gravity east -extent 600x $filegif");
		}
		
		
                #----Topologia: latex-------------------------------------------
		$ffile=$file;
		$ffile=~s/n/_/;
		$ffile=~s/.tex//;
		$ffile="ffig".$ffile;
                $escalaTex=0.5*$escala;
		print "    se ajusta escala para latex:  $escalaTex=0.5*$escala\n";

                moodleFig($dir, $ffile,$id,'300x300',$escalaTex,1, $dd, $dondeestoy);
		
	    };
	}
	close(IFILE);
	if ($dd eq "dd") {
	    ajustarAltura600( $id);
	}
	#ajustarAltura600( $id);
    }
#    if ($dd eq "dd") {
#	ajustarAltura600( $id);
#    }
}
closedir(DIR);


sub ajustarAltura600{
    my ($id)=@_;

    print ("---------ini ajustarAltura600 $id---------------\n");
    # Se determina la altura maxima de los dibujos 'pequeños'
    $aux="identify -format %h drag_drop/$id"."_0.gif";
    printf ("%s\n", $aux);
    $hmax  =qx($aux);
    $aux="identify -format %h drag_drop/$id"."_1.gif";
    printf ("%s\n", $aux);
    $output=qx($aux);
    if ($output>$hmax) {$hmax=$output;}
    $aux="identify -format %h drag_drop/$id"."_2.gif";
    printf ("%s\n", $aux);
    $output=qx($aux);
    if ($output>$hmax) {$hmax=$output;}

    #$hmax=`identify -format %h drag_drop/$id"."_0.gif`;
    ##$hmax  =qx($aux);
    #$output=`identify -format %h drag_drop/$id"."_1.gif`;
    ##$output=qx($aux);
    #if ($output*1>$hmax*1) {$hmax=$output;}
    #$output=`identify -format %h drag_drop/$id"."_2.gif`;
    ##$output=qx($aux);
    #if ($output*1>$hmax*1) {$hmax=$output;}
    
    
    
    print "hmax=$hmax, output=$output, id=$id\n";

    # Se comprueba que la altura de las figuras sobre las que se arrastra
    # el dibujo es mayor
    $hmax=$hmax+80;
    $file="drag_drop/$id"."_0_600.gif";
    $aux="identify -format %h $file";
    $h600=qx($aux);
    printf ("Altura de $file=%d\n",$h600);
    if ($h600 < $hmax) {
	printf("Se aumenta la altura->%d\n",$hmax);
	system ("convert $file -background white -gravity center -extent x$hmax aux.gif; 
		cp aux.gif $file;#"."new.gif;
		rm aux.gif");
    }
    $file="drag_drop/$id"."_1_600.gif";
    $aux="identify -format %h $file";
    $h600=qx($aux);
    printf ("Altura de $file=%d\n",$h600);
    if ($h600 < $hmax) {
	printf("Se aumenta la altura->%d\n",$hmax);
	system ("convert $file -background white -gravity center -extent x$hmax aux.gif; 
		cp aux.gif $file;#"."new.gif;
		rm aux.gif");
    }
    $file="drag_drop/$id"."_2_600.gif";
    $aux="identify -format %h $file";
    $h600=qx($aux);
    printf ("Altura de $file=%d\n",$h600);
    if ($h600 < $hmax) {
	printf("Se aumenta la altura->%d\n",$hmax);
	system ("convert $file  -background white -gravity center -extent x$hmax aux.gif; 
		cp aux.gif $file;#"."new.gif;
		rm aux.gif");
    }
    
}
