#!/usr/bin/perl
#use strict;
#use warnings;
 
use SVG;
 
#   %\moodleDiagrama{Dibujar el diagrama de flectores de la viga representada}{-1.250000,0,0.000000,0; 0.000000,0,5.000000,0}{ 0.000000,0.000000,.500000,-26.562500,1.000000,-68.750000;  0.000000,-68.750000,.166500,39.150325,.333000,119.328400 ;; .333000,119.328400,.416500,136.575325,.500000,146.850000 ;; .500000,146.850000,.750000,104.675000,1.000000,0.000000}{0}{.6}{1}
print ("leido moodleDiagram2svg\n");
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
sub moodleDiagram2svg  {
    #---------------------------------------------------------------------------
    my $topo=shift;
    my $diag=shift;
       $diag=~s/;;/x/g;
    my $W0=shift;
    my $lM=shift;
    my $rM=shift;
    my $H0=shift;
    my $tM=shift;
    my $bM=shift;
    my $sW=shift;

    print "---------- inicio moodleDiagram2svg\n";
    print "    topo=$topo\n";
    print "    diag=$diag\n";
    print "    W0(ancho dibujo)=$W0\n";
    print "    sW(anchoLinea)=$sW\n";
    
    my @Topo = split /;/, $topo;
    $xmin=1000000000; $ymin=$xmin; $xmax=-$xmin; $ymax=$xmax; $lmax=$xmax;
    foreach $bar (@Topo) {
	($x1, $y1, $x2, $y2) = split /,/,$bar;
	if ($x1>$xmax) {$xmax=$x1}
	if ($x2>$xmax) {$xmax=$x2}
	if ($x1<$xmin) {$xmin=$x1}
	if ($x2<$xmin) {$xmin=$x2}
	if ($y1>$ymax) {$ymax=$y1}
	if ($y2>$ymax) {$ymax=$y2}
	if ($y1<$ymin) {$ymin=$y1}
	if ($y2<$ymin) {$ymin=$y2} 
    }
    $X0=-$xmin;
    $Y0=-$ymin;
    if ($xmax-$xmin==0) {
	$escT=($W0)/($ymax-$ymin);
    }
    else {
	$escT=($W0)/($xmax-$xmin);
    }
    $W=$W0+$lM+$rM;
    $margenW=$lM;
    
    $H0=($ymax-$ymin)*$escT;
    $H=$H0;
    $margenH=0*$H0/2+$tM;
 #   print "\nW0=", $W0," ", $xmin," ", $xmax;
 #   print "\nH0=", $H0," ", $ymin," ", $ymax;
    #$W  = int(($xmax-$xmin)*$escT);
    #$H = int(($ymax-$ymin)*$escT);
 #   print "\n--- $H, ($ymax-$ymin)*$escT, $margenH, $H*.2";
    #exit(2);
    
    
    #$margenW=$W*.2;
    #$margenH=$H*.2;

    #if ($margenW>$margenH) {$margenH=$margenW} else {$margenW=$margenH}
    
    #---------------------------------------------------------------------------
    my @Diag = split /;/, $diag;
    $Mmax=-1000000000;
    foreach $bar (@Diag) {
        print "        esf=$bar\n";
	@esf= split /x/, $bar;
	foreach $esf (@esf) {
	    print "            esf=$esf\n";
	    @xM = split /,/,$esf;
	    for ($i=1;$i<=$#xM;$i+=2) {
		#print "i=$i->$xM[i]\n";
		if (abs($xM[$i])>$Mmax) {$Mmax=abs($xM[$i])}
	    }
	}
    }
    print "    Esf max=$Mmax de $diag\n";
    
    $escM=$margenH/$escT/$Mmax*0.9;
    print "    escGRIFOS=$escM\n";
    #---------------------------------------------------------------------------
    #  create an SVG object with a size of WxH pixels
    my $svg = SVG->new(
	width  => $W,
	height => $H+$tM+$bM
	);
    
    
    #---------------------------------------------------------------------------
    foreach $bar (@Topo) {
	print "    topo barra $bar\n";
	($x1, $y1, $x2, $y2) = split /,/,$bar;
	#print "-------------",$x1, $x1*$escT;
	$svg->line(
	    'stroke'         => 'black',
	    'stroke-width'   =>  $sW,
	    x1=>($x1+$X0)*$escT+$margenW, 
	    x2=>($x2+$X0)*$escT+$margenW, 
	    #y1=>-($y1+$Y0)*$escT+$H+$tM+$bM+$margenH,
	    #y2=>-($y2+$Y0)*$escT+$H+$tM+$bM+$margenH
	    y1=>-($y1+$Y0)*$escT+$H+$margenH,
	    y2=>-($y2+$Y0)*$escT+$H+$margenH
	    );
	print "               (x1,y1,x2,y2)=($x1, $y1, $x2, $y2)\n";
	#print "Y0, H/2, margenH: $Y0, $H/2, $margenH \n";
	print "    fin topo barra\n";
	    
    }
    
    #---------------------------------------------------------------------------
    $esAnteriorParabola=0;
    foreach ($i=0;$i<=$#Topo;$i++) {
	($x1, $y1, $x2, $y2) = split /,/, $Topo[$i];
	$l=sqrt(($x2-$x1)*($x2-$x1)+($y2-$y1)*($y2-$y1));
	$s=($y2-$y1)/$l;
	$c=($x2-$x1)/$l;
	#print "$l, $s, $c\n";
	@esf= split /x/, @Diag[$i];
	foreach $esf (@esf) {
	    @xM = split /,/,$esf;
	    if ($#xM==3) {
		($xM1, $M1, $xM2, $M2) = split /,/,$esf;
		$X1=$x1+$c*$l*$xM1+$M1*$s*$escM;
		$Y1=$y1+$s*$l*$xM1-$M1*$c*$escM;
		$X2=$x1+$c*$l*$xM2+$M2*$s*$escM;
		$Y2=$y1+$s*$l*$xM2-$M2*$c*$escM;
		$svg->line(
		    'stroke'         => 'blue',
		    'stroke-width'   =>  $sW,
		    x1=>($X1+$X0)*$escT+$margenW, 
		    y1=>-($Y1+$Y0)*$escT+$H+$margenH,
		    x2=>($X2+$X0)*$escT+$margenW, 
		    y2=>-($Y2+$Y0)*$escT+$H+$margenH);
		$esAnteriorParabola=0;
            }
	    else {
		($xM1, $M1, $xM2, $M2, $xM3, $M3) = split /,/,$esf;
		#### Solo funciona para M2 el L/2
		$M2=2*$M2-($M3+$M1)/2;
		$X1=$x1+$c*$l*$xM1+$M1*$s*$escM;
		$Y1=$y1+$s*$l*$xM1-$M1*$c*$escM;
		$X2=$x1+$c*$l*$xM2+$M2*$s*$escM;
		$Y2=$y1+$s*$l*$xM2-$M2*$c*$escM;
		$X3=$x1+$c*$l*$xM3+$M3*$s*$escM;
		$Y3=$y1+$s*$l*$xM3-$M3*$c*$escM;
		my $path = $svg->get_path(
		    #Modificado 190225 
		    x => [($X1+$X0)*$escT+$margenW,
			  ($X2+$X0)*$escT+$margenW,
			  ($X3+$X0)*$escT+$margenW ],
		    y => [-($Y1+$Y0)*$escT+$H+$margenH,
			  -($Y2+$Y0)*$escT+$H+$margenH,
			  -($Y3+$Y0)*$escT+$H+$margenH],
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
			cx=>($X1+$X0)*$escT+$margenW, 
			cy=>-($Y1+$Y0)*$escT+$H+$margenH,
			r=>$sW/2
			);
		}
		$esAnteriorParabola=1;
		
	    }
	    
	}
    }
    
    
    #-------------------------------------------------------------------------
    $out=sprintf("%s",$svg->xmlify);
    @out=split /\n/,$out;
    
    @outParabola=();
    foreach my $p ( @out ) {
	if ($p =~/path/) {
	    $p =~s/M/C/;
	    $p =~s/L/,/g;
	    push @outParabola, $p;
	} else {
	    push @outParabola, $p;
	}
    }
    print "\n---------- fin moodleDiagram2svg\n";
    return @outParabola
}
