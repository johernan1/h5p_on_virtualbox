
$dir = $ENV{PWD};
$dir0 = $dir;
$dir0 =~ s/.poster//;
#print $dir, "\n";

system("rm -r /tmp/poster");
system("mkdir /tmp/poster");

system("cp $dir0/drag_drop/* tmp"); 
#system("cd tmp; for i in *600.gif; do  convert \$i -rotate 89.9 xxx.gif| giftopnm  xxx.gif | pnmtops > \$i.ps; done");
#system("cd tmp; for i in *600.gif; do   giftopnm  \$i | pnmtops > \$i.ps; done");
#system "inkscape $fileout -e /tmp/xxx.png; 
#        convert /tmp/xxx.png $filegif;
system("cd tmp; for i in *600.svg; do   convert   \$i \${i%.*}.png ; done");
system("cd tmp; for i in *600.gif; do   convert   \$i \${i%.*}.png ; done");
#exit;


$DIR0 =$dir0;
$dir0 =~s/.*Portico/Portico/g;
$dir0 =~s/_/./g;
$dir0 =~s/\/.*//g;

print("% perl poster.pl > poster.tex; pdflatex poster.tex; \n");
print("% $dir\n");
if(defined $ARGV[0]){
    system ("cat iniposter.tex|sed 's/Vigas biapoyadas/$ARGV[0]/'>poster.tex");
}
else {
    system ("cat iniposter.tex|sed 's/Vigas biapoyadas/$dir0/'   >poster.tex");
}
$dir = "tmp";
opendir(DIR, "$dir");
@FILES = readdir(DIR);
$ifila=0; $nfila=3;
$icol=0; $ncol=5;
#my @sFILES = sort @FILES;
#------------------------------------------ Se ordenan
 for (@FILES) {
     push @array2, $_;
     $array2[-1]  =~ s/(^[1-9])_/0$1_/g;
     $array2[-1]  =~ s/(^[0-9][0-9])_/0$1_/g;
}
my @sarray2 = sort @array2;

foreach my $i (@sarray2) {
     push @sFILES, $i;
     $sFILES[-1]  =~ s/^0*//g;
}
#------------------------------------------- Fin ordenación

open(FH, '>>', "poster.tex") or die $!;
foreach $file ( @sFILES) {
    if ($file=~/png/) {
	
	
	if ($icol==0 && $ifila==0) {
	    print FH ("\\begin{columns}[t]\n");
	    print FH ("\\begin{column}{\\sepwid}\\end{column}\n");
	}
	if ($ifila==0) {
	    print FH ("\\begin{column}{\\onecolwid}\n");
	}
	print FH ("\\begin{center}\n");
	$ifila=$ifila+1;
	$aux="$file \n\n";
	$aux =~s/_/./g;
	print FH  $aux;
        if ($ifila==$nfila) {
	    $ifila=0; 
	    $icol=$icol+1;
	}
        if ($icol==$ncol) {
	    $icol=0; 
	}
	print FH ("\\begin{figure}\n");
	print FH ("\\includegraphics[width=0.6\\linewidth]{tmp/$file}\n");
	print FH ("\\end{figure}\n");
	print FH ("\\end{center}\n\n");

	if ($ifila==3) {
	    print FH ("\\rule{0mm}{5mm}\n"); 
	    #print FH ("\\hrule\n");
	}
	    
	if ($ifila==0) {
	    print FH ("\\end{column}\n");
	}
	if ($icol==0 && $ifila==0) {
	    print FH ("\\begin{column}{\\sepwid}\\end{column}\n");
	    print FH ("\\end{columns}\n\n");
	    #print FH ("\\hrule\n\n");
	}
    }
}
if ($ifila!=0) {
    print FH ("\\end{column}\n");
}
if (not($icol==0 && $ifila==0)) {
    print FH ("\\begin{column}{\\sepwid}\\end{column}\n");
    print FH ("\\end{columns}\n\n");
}
print FH ("\\end{document}\n\n");

closedir(DIR);
print FH ("% Copiar el directorio \tmp de la maquina virtual a esta maquina\n");
print FH ("% Escribir en la maquina virtual:\n");
print FH ("% scp /tmp/* 10.0.2.2:Escritorio/tmp\n");
print FH ("% perl poster.pl > poster.tex; latex poster.tex; dvipdf poster.dvi\n");
print FH ("% \n");
system(" pdflatex poster.tex; mv poster.pdf $DIR0");

