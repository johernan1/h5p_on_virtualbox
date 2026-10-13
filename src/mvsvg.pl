#!/usr/bin/perl
#use strict;
#use warnings;

print ("leido mvsvg\n");
sub mvsvg {
    print ("\n inicio mvsvg\n");
    print ("\n Solo funciona despues de inkscape fileout  --export-plain-svg=xxx.svg --export-area-drawing ...\n");
    my $file=shift;
    my $ofile=shift;
    my $lM=shift;
    my $rM=shift;
    my $uM=shift;
    my $dM=shift;
    my $mywidth=shift;
    my $scale;
	
    open(I_FILE, "$file")
	or die "Could not open input file '$file' $!";
    open(O_FILE,  "> $ofile")
	or die "Could not open output file '$ofile' $!";
    
    $aux="grep width= $file| sed 's/.*width=//'| sed 's/\"//g'";
    print "$aux\n";
    $val=qx($aux);
    chop($val);
    $myscale=$mywidth/$val;
    $lMesc=$lM/$myscale;
    $uMesc=$uM/$myscale;
    
    print ("\n width=$val, myscale=$myscale\n");
    while (my $row = <I_FILE>) {
        if ($row=~/ width="/) {
	    my $val=$row;
	    $val=~s/.*="//;
	    $val=~s/".*//;
	    $myscale=$mywidth/$val;
	    #my $newval=$val+$lM+$rM;
	    my $newval=$mywidth+$lM+$rM;
	    $row=~s/".*"/"$newval"/;
	}
        if ($row=~/ height="/) {
	    my $val=$row;
	    $val=~s/.*="//;
	    $val=~s/".*//;
	    #my $newval=$val+$uM+$dM;
	    my $newval=$val*$myscale+$uM+$dM;
	    $row=~s/".*"/"$newval"/;
	}
	if ($row=~/<line/ || $row=~/<path/ || $row=~/<circle/) {
	    $row="$row transform=\"scale($myscale) translate($lMesc, $uMesc)\"\n";
	    #$row="$row transform=\"scale($myscale) \"\n";
	}
#	if ($row=~/x1=/ || $row=~/x2/|| $row=~/cx/) {
#	    my $val=$row;
#	    $val=~s/.*="//;
#	    $val=~s/".*//;
#	    my $newval=$val+$lM;
#	    $row=~s/".*"/"$newval"/;
#	}
#	if ($row=~/y1=/ || $row=~/y2/|| $row=~/cy/) {
#	    my $val=$row;
#	    $val=~s/.*="//;
#	    $val=~s/".*//;
#	    my $newval=$val+$uM;
#	    $row=~s/".*"/"$newval"/;
#	}
#	if ($row=~/ d="m/) {
#	    my @val=split / /, $row;
#	    (my $x1, $y1) = split /,/, $val[6]; $x1=$x1+$lM; $y1=$y1+$uM;
#	    (my $x2, $y2) = split /,/, $val[8]; $x2=$x2+$lM; $y2=$y2+$uM;
#	    (my $x3, $y3) = split /,/, $val[9]; $x3=$x3+$lM; $y3=$y3+$uM;
#	    #print ("---------$x, $y");
#	    #foreach my $val (@val) {
#	#		print "xxxxx $val\n";
#		
#	    $row=~s/$val[6]/$x1,$y1/;		
#	   # $row=~s/$val[8]/$x2,$y2/;
#	   # $row=~s/$val[9]/$x3,$y3/;
#	}
#	
#	if ($row=~/ d="M/) {
#	    my @val=split / /, $row;
#	    (my $x1, $y1) = split /,/, $val[6]; $x1=$x1+$lM; $y1=$y1+$uM;
#	    (my $x2, $y2) = split /,/, $val[8]; $x2=$x2+$lM; $y2=$y2+$uM;
#	    (my $x3, $y3) = split /,/, $val[9]; $x3=$x3+$lM; $y3=$y3+$uM;
#	    #print ("---------$x, $y");
#	    #foreach my $val (@val) {
#	#		print "xxxxx $val\n";
#		
#	    $row=~s/$val[6]/$x1,$y1/;		
#	    $row=~s/$val[8]/$x2,$y2/;
#	    $row=~s/$val[9]/$x3,$y3"/;
#	}
    

	
    print O_FILE $row;
    }
    close (I_FILE);
    close (O_FILE);

    print ("\n fin mvsvg (if=$file, of=$ofile)\n");
}

    
