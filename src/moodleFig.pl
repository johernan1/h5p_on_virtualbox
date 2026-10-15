#!/usr/bin/perl
use Digest::SHA;

print "    fichero moodleFig\n"; 

sub moodleFig{
    my $Sub="moodleFig";
 #   if (defined($dbh)) {iniSub($Sub);} else {return;}
    #iniSub($Sub);
    print "---- inicio moodleFig ----------------------------------------\n";
    my ($dir,$fichero,$n, $nmax, $escalafig, $escalaMoodle, $dd, $dondeestoy)=@_;
    

    #if (!defined($dbh)) {
#	finSub($Sub);
#	return;}
   
    print "escalafig=$escalafig\n";
    #$escalafig=0.5*$escalafig;
    if ($escalafig==0) {$escalafig=0.5;}
    print "escalafig=$escalafig\n";
    if ($escalaMoodle==0) {$escalaMoodle=1;}
   

    open(TMPFICHFIG, "> /tmp/$ENV{USER}/$fichero-$n.tex");
    print TMPFICHFIG '
\documentclass[10pt,a4paper]{report}
%Generado automaticamente en moodleFig
\usepackage{graphicx}
\usepackage[latin1]{inputenc}
\usepackage[spanish]{babel}
\usepackage{graphicx,psfrag,calc}
\usepackage{rotating}
\usepackage{/home/johernan/ETSAM/stytest/sty/ptest1}

\renewcommand{\baselinestretch}{0,85}


\begin{document}
\renewcommand{\ESCALA}{.9\linewidth}
\dosMP{0.5\linewidth}{.5217} {
     \dosMP{0.5\linewidth}{'.$escalafig.'} {
     \input{'.$fichero.'}
     }{}
}{}
\end{document}
';
    close(TMPFICHFIG);
    $RES="300x300";
    $RES=$nmax;
    $DIRMOODLE="/usr/share/moodledata";
    $DIRMOODLE="/var/lib/moodle/filedir";
    #$mdl_curso=moodleCurso($CURSO);

    print "--------------------------latex $fichero-$n.tex\n\n";
    # Dependiendo de la maquina la salidad de latex hay que rotarla o no
    if ($dondeestoy=~/escuela/) {
	$rotar="";
    }
    else {
	$rotar="| pnmrotate 90 ";}
    
	    
    system "cp $dir/f$n_*.ps /tmp/$ENV{USER};
            cp $dir/$fichero /tmp/$ENV{USER};
            cd /tmp/$ENV{USER};
            latex $fichero-$n.tex > latex.out.$fichero-$n; 
            dvips -q -o $fichero-$n.ps $fichero-$n ;
            gs -sDEVICE=ppmraw -r$RES -sOutputFile=- -sNOPAUSE -q $fichero-$n.ps -c showpage -c quit | pnmcrop | pnmmargin -white 10 $rotar | pnmcrop | pnmmargin -white 10 |  ppmquant 256 | ppmtogif > $fichero-$n.gif;
            convert $fichero-$n.gif -resize 430x $fichero-$n-430.gif;
            convert $fichero-$n.gif -resize 150x $n"."_0.gif;";
#    print "cp $dir/f$n.ps /tmp;
#            cp $dir/$fichero /tmp;
#            cd /tmp;
#            latex $fichero-$n.tex > latex.out.$fichero-$n; 
#            dvips -q -o $fichero-$n.ps $fichero-$n ;
#            gs -sDEVICE=ppmraw -r$RES -sOutputFile=- -sNOPAUSE -q $fichero-$n.ps -c showpage -c quit | pnmcrop $rotar | pnmcrop | pnmmargin -white 10 |  ppmquant 256 | ppmtogif > $fichero-$n.gif;
#            convert $fichero-$n.gif -resize 430x $fichero-$n-430.gif;
#    convert $fichero-$n.gif -resize 150x $n"."_0.gif;";

    #-------Se ajusta altura, si procede
    $aux="identify -format %h /tmp/$ENV{USER}/$fichero-$n-430.gif";
    $h600=qx($aux);
    print "$aux\nh->$h600";
    $anchodd=600;
    $hmax=300;
    if ($h600>300){
	system "cd /tmp/$ENV{USER}; convert $fichero-$n.gif -resize x".$hmax." $fichero-$n-430.gif;";
	#$aux="identify -format %w /tmp/$fichero-$n-430.gif";
	#$w600=qx($aux);
        #$anchodd=$w600+20+20+$hmax/$h600*150;
	#print "$aux, w=$w600, h=$h600, anchodd=$anchodd = $w600+20+430/$h600*150\n";

	#if ($anchodd>600) {$anchodd=600;}
	
    }
    $aux="identify -format %h /tmp/$ENV{USER}/$n"."_0.gif";
    $h150=qx($aux);
    print "$aux\nh->$h150";
    if ($h150>150){
	system "cd /tmp/$ENV{USER}; convert $n"."_0.gif -resize x150 $n"."_0.gif;"
    }
    #exit;
    
    #-------Se añade espacio para dyd------------------------------------------
    #-------se cambia el nombre del fichero 669794902
    if ($dd eq "dd") {
	#system "cd /tmp; convert $fichero-$n-430.gif -background white -gravity east -extent 600x  $n"."_0_600.gif;";
	system "cd /tmp/$ENV{USER}; convert $fichero-$n-430.gif -background white -gravity center  -extent 430x  xxx.gif;";
	system "cd /tmp/$ENV{USER}; convert xxx.gif -background white -gravity east -extent $anchodd"."x  $n"."_0_600.gif;";
	#print "cd /tmp; convert $fichero-$n-430.gif -background white -gravity east -extent $anchodd"."x  $n"."_0_600.gif;\n";
	#exit;
    } else {
	system "cd /tmp/$ENV{USER}; convert $fichero-$n-430.gif -background white -gravity center  -extent 430x  $n"."_0_600.gif;";
	#system "cd /tmp; mv $fichero-$n-430.gif $n"."_0_600.gif";
    }

    #-------Se mueven los resultados al ficero dyd
    system "ls /tmp/$ENV{USER}/*gif";
    system "mv /tmp/$ENV{USER}/*$n"."_0.gif drag_drop;
            mv /tmp/$ENV{USER}/*$n*600.gif drag_drop;
            #rm /tmp/*tex;
            #rm /tmp/*ps;
            #rm /tmp/ffig*;
            ";

    print "---- fin moodleFig ----------------------------------------\n";
    #exit;
}
