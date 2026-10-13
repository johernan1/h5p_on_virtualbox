#!/usr/bin/perl
use strict;
#use warnings;
 
use SVG;
 
#   %\moodleDiagrama{Dibujar el diagrama de flectores de la viga representada}{-1.250000,0,0.000000,0; 0.000000,0,5.000000,0}{ 0.000000,0.000000,.500000,-26.562500,1.000000,-68.750000;  0.000000,-68.750000,.166500,39.150325,.333000,119.328400 ;; .333000,119.328400,.416500,136.575325,.500000,146.850000 ;; .500000,146.850000,.750000,104.675000,1.000000,0.000000}{0}{.6}{1}
print ("leido newmoodleDiagram2svg\n");
#-------------------------------------------------------------------------------
sub moodleDiagram2svg2file {
    my $of=shift;
    my $topo=shift;
    my $diag=shift;
    my $width=shift;
    my $hmax=shift;
    my $margenes=shift;
    my $sW=shift;

    my $dsvg;

    print "---------- inicio moodleDiagram2svg2file\n";
    print "    of=$of\n";
    

    # $topo y diag GRIFO en formato moodleDiagramas
    # $width ancho del dibujo
    # $hmax altura máxima. Si la altura del dibujo es mayor se ajusta
    # conservando el $width

    my @dsvg=newmoodleDiagram2svg($topo, $diag, 
				  $width, 
				  $sW
	);
	print "    261011 Creado diagrama en formato svg\n";
    open(OFILE,  "> /tmp/xxx.svg")
	or die "Could not open file '$of' $!";
    print OFILE @dsvg;
    close (OFILE);
    
    # Añadido 190225 para "craquear" errata
    # perl::svg crea curvas de grado 3 (cúbicas)
    # por lo que las nuevas versiones de 'convert' se lían
    # Se manipula el fichero generado para que la curva sea una
    # parábola. No he sido capaz de reproducir &Q con perl
    # & es aprox la exprexion regular ()->$1
    
    system " sed 's/path d=.C[e 0-9.\-]*,/&Q/g' /tmp/xxx.svg | 
	     sed 's/=\"C/=\"M/g'  | sed 's/,Q/Q/g' > /tmp/xxx2.svg;";

    # Se ajustan ("quitan") los margenes
	print "    inkscape /tmp/xxx2.svg  --export-plain-svg=/tmp/xxx3.svg --export-area-drawing\n";
    system "inkscape /tmp/xxx2.svg  --export-plain-svg=/tmp/xxx3.svg --export-area-drawing";
    # Y se vuelve ajustar el ancho
    mvsvg ("/tmp/xxx3.svg", $of, $margenes, $margenes, $margenes, $margenes,
	   $width-2*$margenes);
    
    # Y ahora se comprueba la altura
    my $aux="identify -format %h $of";
    my $hdibujo=qx($aux);
    print "    hdibujo=$hdibujo\n";
    my $escala=1;
    if ($hdibujo>$hmax) {
	#system ("cp $of /tmp/xxx4.svg");
	#$aux="identify -format %w $of";	    
	#my $wdibujo=qx($aux);
	system "inkscape $of  --export-plain-svg=/tmp/xxx4.svg --export-area-drawing;";
	$aux="identify -format %h /tmp/xxx4.svg";
	$hdibujo=qx($aux);
	$aux="identify -format %w /tmp/xxx4.svg";	    
	my $wdibujo=qx($aux);
	
	# Ahora se busca el ancho del dibujo para que $hdibujo=$hmax-2*margenes
	my $newAncho=$wdibujo*($hmax-2*$margenes)/$hdibujo;
	$escala=($hmax-2*$margenes)/$hdibujo; #para return
	print "    escala para latex: $escala=($hmax-2*$margenes)/$hdibujo\n";
	mvsvg ("/tmp/xxx4.svg",$of,$margenes, $margenes, $margenes, $margenes, 
	       $newAncho);
	#
	#my $newmar=($width-$newAncho)/2;
	#print "    Se ajusta ancho: $wdibujo->";
	#
	#mvsvg ("/tmp/xxx4.svg",$of,$newmar, $newmar, $margenes, $margenes, 
	#       $width-2*$newmar);
    }
    print "---------- fin    moodleDiagram2svg2file\n"; #exit;
    return 3*$escala;
}


#-------------------------------------------------------------------------------
sub newmoodleDiagram2svg  {
    #---------------------------------------------------------------------------
    my $topo=shift;
    my $diag=shift;
       $diag=~s/;;/x/g;
    my $W0=shift;
    my $sW=shift;

    print "    ---------- inicio newmoodleDiagram2svg\n";
    print "        topo=$topo\n";
    print "        diag=$diag\n";
    print "        W0(ancho dibujo)=$W0\n";
    print "    sW(anchoLinea)=$sW\n";
    
    my @Topo = split /;/, $topo;
    my $xmin=1000000000;
    my $ymin=$xmin;
    my $xmax=-$xmin;
    my $ymax=$xmax;
    my $lmax=$xmax;
    foreach my $bar (@Topo) {
	(my $x1, my $y1, my $x2, my $y2) = split /,/,$bar;
	if ($x1>$xmax) {$xmax=$x1}
	if ($x2>$xmax) {$xmax=$x2}
	if ($x1<$xmin) {$xmin=$x1}
	if ($x2<$xmin) {$xmin=$x2}
	if ($y1>$ymax) {$ymax=$y1}
	if ($y2>$ymax) {$ymax=$y2}
	if ($y1<$ymin) {$ymin=$y1}
	if ($y2<$ymin) {$ymin=$y2} 
    }
    my $X0=-$xmin;
    my $Y0=-$ymin;
    my $escT;
    if ($xmax-$xmin==0) {
	$escT=($W0)/($ymax-$ymin);
    }
    else {
	$escT=($W0)/($xmax-$xmin);
    }
    print "    X0=$X0\n";
    print "    Y0=$Y0\n";
    print "    escT=$escT\n";
    print "    incx*escT=($xmax-$xmin)*$escT=".($xmax-$xmin)*$escT."\n";
#    $W=$W0+$lM+$rM;
#    $margenW=$lM;
#    
#    $H0=($ymax-$ymin)*$escT;
#    $H=$H0;
    my $H=($ymax-$ymin)*$escT; #En vigas este valor es 0, pero luego se
                               #ajustan los margenes y el tamaño de la figura
#    $margenH=0*$H0/2+$tM;
# #   print "\nW0=", $W0," ", $xmin," ", $xmax;
# #   print "\nH0=", $H0," ", $ymin," ", $ymax;
#    #$W  = int(($xmax-$xmin)*$escT);
#    #$H = int(($ymax-$ymin)*$escT);
# #   print "\n--- $H, ($ymax-$ymin)*$escT, $margenH, $H*.2";
#    #exit(2);
#    
#    
#    #$margenW=$W*.2;
#    #$margenH=$H*.2;
#
#    #if ($margenW>$margenH) {$margenH=$margenW} else {$margenW=$margenH}
#    
#    #--------------------------------------------------------------------------#-
    my @Diag = split /;/, $diag;
    my $Mmax=-1000000000;
    foreach my $bar (@Diag) {
        print "        esf=$bar\n";
	my @esf= split /x/, $bar;
	foreach my $esf (@esf) {
	    print "            esf=$esf\n";
	    my @xM = split /,/,$esf;
	    for (my $i=1;$i<=$#xM;$i+=2) {
		#print "i=$i->$xM[i]\n";
		if (abs($xM[$i])>$Mmax) {$Mmax=abs($xM[$i])}
	    }
	}
    }
    print "    Esf max=$Mmax de $diag\n";

    # El 15% del maximo de incX o incY
    my $escM;
    if ($xmax-$xmin > $ymax-$ymin) {
	$escM=(0.25*($xmax-$xmin)*$escT)/$Mmax;
    } else {
	$escM=(0.25*($ymax-$ymin)*$escT)/$Mmax;
    }
#    #$escM=$W0/$Mmax*0.25;
    print "    newescGRIFOS=$escM. escM*Mmax=$escM*$Mmax=".$escM*$Mmax."\n";
#    #---------------------------------------------------------------------------
    #  create an SVG object with a size of WxH pixels
    my $svg = SVG->new(
	width  => $W0,
	height => $H
	);
    
    
    #---------------------------------------------------------------------------
    foreach my $bar (@Topo) {
	print "    ** topo barra $bar\n";
	(my $x1, my $y1, my $x2, my $y2) = split /,/,$bar;
	#print "-------------",$x1, $x1*$escT;
	$svg->line(
	    'stroke'         => 'black',
	    'stroke-width'   =>  $sW,
	    x1=>($x1+$X0)*$escT, 
	    x2=>($x2+$X0)*$escT, 
	    #y1=>-($y1+$Y0)*$escT+$H+$tM+$bM+$margenH,
	    #y2=>-($y2+$Y0)*$escT+$H+$tM+$bM+$margenH
	    y1=>-($y1+$Y0)*$escT+$H,
	    y2=>-($y2+$Y0)*$escT+$H
	    );
	print "               (x1,y1,x2,y2)=($x1, $y1, $x2, $y2)\n";
	#print "Y0, H/2, margenH: $Y0, $H/2, $margenH \n";
	print "    ** fin topo barra\n";
	    
    }
    
    #---------------------------------------------------------------------------
    my $esAnteriorParabola=0;
    foreach (my $i=0;$i<=$#Topo;$i++) {
	(my $x1, my $y1, my $x2, my $y2) = split /,/, $Topo[$i];
	my $l=sqrt(($x2-$x1)*($x2-$x1)+($y2-$y1)*($y2-$y1));
	my $s=($y2-$y1)/$l;
	my $c=($x2-$x1)/$l;
	#print "$l, $s, $c\n";
	my @esf= split /x/, @Diag[$i];
	foreach my $esf (@esf) {
	    my @xM = split /,/,$esf;
	    if ($#xM==3) {
		(my $xM1, my $M1, my $xM2, my $M2) = split /,/,$esf;
		my $X1=$x1+$c*$l*$xM1+$M1*$s*$escM/$escT;
		my $Y1=$y1+$s*$l*$xM1-$M1*$c*$escM/$escT;
		my $X2=$x1+$c*$l*$xM2+$M2*$s*$escM/$escT;
		my $Y2=$y1+$s*$l*$xM2-$M2*$c*$escM/$escT;
		$svg->line(
		    'stroke'         => 'blue',
		    'stroke-width'   =>  $sW,
		    x1=>($X1+$X0)*$escT, 
		    y1=>-($Y1+$Y0)*$escT+$H,
		    x2=>($X2+$X0)*$escT, 
		    y2=>-($Y2+$Y0)*$escT+$H);
		$esAnteriorParabola=0;
            }
	    else {
		(my $xM1, my $M1, my $xM2, my $M2, my $xM3, my $M3) = split /,/,$esf;
		#### Solo funciona para M2 el L/2
		$M2=2*$M2-($M3+$M1)/2;
		my $X1=$x1+$c*$l*$xM1+$M1*$s*$escM/$escT;
		my $Y1=$y1+$s*$l*$xM1-$M1*$c*$escM/$escT;
		my $X2=$x1+$c*$l*$xM2+$M2*$s*$escM/$escT;
		my $Y2=$y1+$s*$l*$xM2-$M2*$c*$escM/$escT;
		my $X3=$x1+$c*$l*$xM3+$M3*$s*$escM/$escT;
		my $Y3=$y1+$s*$l*$xM3-$M3*$c*$escM/$escT;
		my $path = $svg->get_path(
		    #Modificado 190225 
		    x => [($X1+$X0)*$escT,
			  ($X2+$X0)*$escT,
			  ($X3+$X0)*$escT ],
		    y => [-($Y1+$Y0)*$escT+$H,
			  -($Y2+$Y0)*$escT+$H,
			  -($Y3+$Y0)*$escT+$H],
		    -type => 'path',
		    -close=>'0');
		
		$svg->path(
		    %$path,
		    style => {
			#'fill'           => 'transparent', #'rgb(0,0,255)',
			'stroke'         => 'red',
			'stroke-width'   =>  $sW,
			'stroke-opacity' =>  1,
			'fill-opacity'   =>  0,
		    },
		    );
		
		if($esAnteriorParabola==1) {	    
		    $svg->circle(
			'stroke'         => 'blue',
			'stroke-width'   =>  $sW/2,
			'fill'=>'red',
			cx=>($X1+$X0)*$escT, 
			cy=>-($Y1+$Y0)*$escT+$H,
			r=>$sW/2
			);
		}
		$esAnteriorParabola=1;
		
	    }
	    
	}
    }
    
    
    #-------------------------------------------------------------------------
    my $out=sprintf("%s",$svg->xmlify);
    my @out=split /\n/,$out;
    
    my @outParabola=();
    foreach my $p ( @out ) {
	if ($p =~/path/) {
	    $p =~s/M/C/;
	    $p =~s/L/,/g;
	    push @outParabola, $p;
	} else {
	    push @outParabola, $p;
	}
    }
    print "\n    ---------- fin     newmoodleDiagram2svg\n";
    return @outParabola
}
    
