#!/usr/bin/perl
#
# 
# perl drag_drop.pl -> dibujos para multichioice
# perl drag_drop.pl dd -> dibujos para drag&drop
use Cwd qw(cwd);
my $dir = cwd;

$PATH="$dir/../src";

do "$PATH/moodleDiagram2svg.pl";
do "$PATH/mvsvg.pl";
do "$PATH/moodleFig.pl";
#do './excel.pl';
#tituloExcel();


#-------------------------------------------------------------------------
$colExcel="multichoicegrifos";
$multichoice="multichoice";
$titulo="mc";
if ($ARGV[1] eq "dd") {
    $titulo="dyd";
    $multichoice="dragdrop";
    $colExcel="dragdrop";
}
#-------------------------------------------------------------------------
use Spreadsheet::WriteExcel;
# Create a new workbook called simple.xls and add a worksheet
my $workbook  = Spreadsheet::WriteExcel->new("$multichoice.xls");
my $excel_question = $workbook->add_worksheet("excel_question");
my $excel_variables = $workbook->add_worksheet("excel_variables");
$nfilaExcel=0;
tituloExcel();
if ($ARGV[0] ne undef) {$titulo=$titulo.$ARGV[0];}
hojaexcel_Variables($titulo);

#-------------------------------------------------------------------------

$dir = "tex";
#system "rm drag_drop/*";
opendir(DIR, "$dir")
	    or die "Could not open dir '$dir' $!";
@FILES = readdir(DIR);
#-------------------------------------------------------------------------
# Columnas del fichero excel

open(OFILE, ">excel.txt")
	    or die "Could not open file 'excel.txt' $!";
@id=();
foreach $file (@FILES) {
    if ($file=~/tex/) {
        $id=$file;
	$id=~s/.*n//;
        $id=~s/.tex//;
        push @id,$id;
    }
}
print "Se procesan los dibujos: @id\n";

$ii=1; $ndrag=5;
foreach $id (@id) {
    for ($i=1;$i<=3;$i++) {
	$i1=$i % 3;
	$i2=($i+1) % 3;
	$i3=($i+2) % 3;
	$ii++;
	$idrop=($ii % $ndrag)+1;

	
	if ($i1==0) {
	    print OFILE "drag_drop/$id"."_$i1"."_600.gif\t";
	} else {
	    print OFILE "drag_drop/$id"."_$i1"."_600.svg\t";
	}
	#print OFILE "drag_drop/$id"."_$i1"."_600.gif\t";
	$dragdropexcel='';
	@idImagenes=();
	for ($idrp=1;$idrp<=$ndrag;$idrp++) {
	    print "-------------------------------------------------\n";
	    print "RESPUESTA $idrp\n";
            if ($idrp==$idrop) { # Respuesta correcta:
                $MVrnd=int(rand(3));
		while ($MVrnd==$i1) { # Si el diagrama para arrastrar es el
		                      # mismo que el patron se busca otro
		                      # De este modo se evita que la respuesta
		                      # correcta sea la misma que el patron
		    $MVrnd=int(rand(3));
		}
		printf("**OK $i1->$MVrnd\n");
		if ($MVrnd==0) {
		    $dragdropexcel="$dragdropexcel;drag_drop/$id"."_$MVrnd.gif";
            	} else {
		    $dragdropexcel="$dragdropexcel;drag_drop/$id"."_$MVrnd.svg";
		}
	    }
	    else # Respuestas incorrectas
	    {
		#$irnd=@id[int(rand($#id))];
                $irnd=$id; # De este modo lo siguiente se procesa una vez
		           # por lo menos
		while ($irnd==$id) { # Si el irnd aleatorio coincide con el id
		                     # del dibujo patron se busca otro aleat.
		                     # Así se evita que entre las respuestas
		                     # NO correctas se incluya alguna válida
		     
                    print "    imagenes incorrectas. reintento $irnd-> (se busca un numero aleatorio $#id para indice de (@id)->";
		    $irnd=@id[int(rand($#id+1)+1)];
		    while ($irnd==$id || $irnd=='') {
			$irnd=@id[int(rand($#id+1))];
		    }
                    print " ---$irnd"."---\n";
		    foreach $idImagen (@idImagenes) {
                        print "\n              imagenes incorrectas chk:  $idImagen\n";
			if ($idImagen==$irnd) {
			    print "    reintento porque ya se ha usado la respuesta $irnd";
			    $irnd=$id; # Si el irnd aleatorio ya se ha utilizado
			               # se busca otro (se hace irnd=id y no se
			               # sale del while
			}
		    }
                    print "    $irnd: Tienen que definirse tres dibujos \n";
		}
                push @idImagenes,$irnd; 
                print " imagenes incorrectas FINALES:  @idImagenes\n";
			
		$MVrnd=int(rand(3));
		while ($MVrnd==$i1) { # Si el diagrama para arrastrar es el
		                      # mismo que el del patron se busca otro
		                      # Así se evita que entre las respuestas
		                      # NO correctas se incluyan diagramas del
		                      # mismo tipo que el patron
		    $MVrnd=int(rand(3));
		}
		printf("Tipo patron: $i1 (0=q,1=M, 2=V)-> Tipo respuesta incorrecta-> $MVrnd\n");
		
		if ($MVrnd==0) {
		    $dragdropexcel="$dragdropexcel;drag_drop/$irnd"."_$MVrnd.gif";
            	} else {
		    $dragdropexcel="$dragdropexcel;drag_drop/$irnd"."_$MVrnd.svg";
		}
#		    $dragdropexcel="$dragdropexcel;drag_drop/$irnd"."_$MVrnd.gif";
	    }
	#print "    $dragdropexcel\n";
	}
	$dragdropexcel=substr $dragdropexcel, 1 ;
	print OFILE "$dragdropexcel\t$idrop\n";

	if ($i1==0) {
	    addLineExcel ("drag_drop/$id"."_$i1"."_600.gif", $dragdropexcel, $idrop);
	} else {
	    addLineExcel ("drag_drop/$id"."_$i1"."_600.svg", $dragdropexcel, $idrop);
	}	
	#addLineExcel ("drag_drop/$id"."_$i1"."_600.gif", $dragdropexcel, $idrop);
	#print "xxxxx$id.$i1.600.gif->$id.$i3.gif->idrop:$idrop\n";
    }
}
close(OFILE);

#------------------------------------------------------------------------------
# Funciones fichero excel


sub tituloExcel {
    @cols= qw(id	questiontext	answer	tolerance	image	-	choice); push (@cols,	$colExcel);
    $icol=0;
    foreach $col (@cols) {
	$excel_question->write($nfilaExcel, $icol,  $col);
	$icol=$icol+1;
	#print "\n\n\ntituloExcel $icol-> $col\n\n\n\n";
    }
    $nfilaExcel=$nfilaExcel+1;
}
sub addLineExcel {
    my $fig600x600=shift;
    my $figs=shift;
    my $figOK=shift;
    
    $excel_question->write($nfilaExcel, 0,  $nfilaExcel);
    $excel_question->write($nfilaExcel, 4,  $fig600x600);
    $excel_question->write($nfilaExcel, 7,  $figs);
    $excel_question->write($nfilaExcel, 6,  $figOK);
    $nfilaExcel=$nfilaExcel+1;
}
sub hojaexcel_Variables {

    my $titulo=shift;
    
    @vars= qw(var
	      shortname
	      ejercicio
	      semana
	      excel_question
	      excel_quiz_intro
	      excel_question_categories
	      excel_quiz_question_instances
	      excel_course_modules
	      excel_groupings_groups
	      debug);
    
    @vals =qw(val
	      dyd
	      EJERCICIO
	      2
	      excel_question
	      excel_quiz_intro
	      excel_question_categories
	      excel_quiz_question_instances
	      excel_course_modules
	      excel_groupings_groups
	      0);
    $nc=0;
    foreach $var (@vars) {
	$excel_variables->write($nc,0,$var);
	$nc=$nc+1;
    }
    $nc=0;
    foreach $val (@vals) {
	$excel_variables->write($nc,2,$val);
	if ($val =~ /EJERCICIO/) {
	    $excel_variables->write($nc,2, $titulo);
	}
	if ($val =~ /excel_quiz_intro/) {
	    $excel_variables->write($nc,2,"Para responder este ejercicio se dispone de diez minutos que empiezan a contar en el momento que se inicia. Durante esos diez minutos se pueden hacer cinco intentos. La calificación final será la del mejor intento realizado.");
	}
	$nc=$nc+1;
    }
    

}
