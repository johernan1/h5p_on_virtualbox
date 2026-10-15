#!/usr/bin/perl
#
#
# Elimina los patrones
#    0.000000,-.000010,.000100,-.000010 ;;
# de las lineas "moodleDiagrama" de los ficheros tex


print "-----------      postGrifos ----------------------\n";
postGrifos();

sub postGrifos {
    my $file, $dir;
    
    $dir = "tex";
    opendir(DIR, "$dir")
	or die "Could not open dir '$dir' $!";
    @FILES = readdir(DIR);

    foreach $file (@FILES) {
	if ($file=~/tex/) {
	    print "-----------      postGrifos $file------------------\n";
	    if (postGrifo("$dir/$file") eq 1) {
		print "-----------      postGrifos $file------------------\n";
		system ("diff /tmp/$ENV{USER}/of.tex $dir/$file");
		system ("cp /tmp/$ENV{USER}/of.tex $dir/$file");
		print "-----------(fin) postGrifos $file------------------\n";
	    }
	}
    }
}


sub postGrifo {
    my $file=shift;
    my $cambios;

    $cambios=0;
    open(IFILE, "$file")
	    or die "Could not open file '$file' $!";
    open(OFILE, "> /tmp/$ENV{USER}/of.tex")
	    or die "Could not open file '> /tmp/$ENV{USER}/of.tex' $!";
    while (my $row = <IFILE>) {
	if ($row=~/moodleDiagram/) {
	    # El valor de Xcer y Xuno esta calibrado en cargas.mws
	    # Se eliminan vacios por la izquierda
	    if ($row=~/0.000000,[-.0-9 ,]*,.000100,[-.0-9]* ;;/) {
		#print "-------->$row";
		$row=~s/0.000000,[-.0-9 ,]*,.000100,[-.0-9]* ;;//;
		#print "-------->$row";
		$cambios=1;
	    }
	    # Se eliminan vacios por la derecha
	    if ($row=~/;; .999990,[-.0-9 ,]*,1.000000,[-.0-9]*[};]/) {
		#print "-------->$row";
		$row=~s/;; .999990,[-.0-9 ,]*,1.000000,[-.0-9]*([};])/$1/g;
		#print "-------->$row";	
		$cambios=1;
	    }
	    # Se hacen cero los casi ceros en los esfuerzos a la izquierda
	    # Puede causar algún error en algun elemento cuyo esfuerzo sea muy
	    # pequeño no debido a errores de redondeo. 
	    if ($row=~ /[0-9]\}\{[ 0]*.0000[01]0,[-0 ]*\.00/) {
		#print "-------->$row";
		$row=~s/[0-9]\}\{[ 0]*.0000[01]0,[-0 ]*\.00[0-9]*,/}{0.0,0.0,/;
		#print "-------->$row";	
		$cambios=1;
	    }
	    # Se hacen cero los casi ceros en los esfuerzos a la derecha
	    # Puede causar algún error en algun elemento cuyo esfuerzo sea muy
	    # pequeño no debido a errores de redondeo. 
	    if ($row=~ /,\.0000[0-9]*[ ]*\}\{/) {
		#print "-------->$row";
		$row=~s/,\.0000[0-9]*[ ]*\}\{/,0.0}{/g;
		#print "-------->$row";	
		$cambios=1;
	    }
	    
	}
	print OFILE "$row";
    }
    close OFILE;
    return $cambios;
}
