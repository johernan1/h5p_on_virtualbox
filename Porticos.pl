# NOTA IMPORTANTE--------------------------------------------------------------
# No olvidar enlaces (que no se copian con owncloud)
#      180916-consultas_basicas/E4/src -> ../src
#      180916-consultas_basicas/E4/src/auxi/auxi.pl -> auxi-color.pl
# USO--------------------------------------------------------------------------
# perl Porticos.pl 4 2020
#      procesa el modelo 2020 de maple/newPortico.mws
#      4 -> multichoice (ver comentarios posteriores)
# perl Porticos.pl 6 2010
#      procesa el modelo 2010 de maple/newPortico.mws
#      6 -> dd (ver comentarios posteriores)
# perl Porticos.pl 6 2010,2020
#      procesa los modelos 2010 y 2020
# perl Porticos.pl 3 2010
#      procesa el modelo 2010
#      3 -> h5p (ver comentatios posteriores)
# perl Porticos.pl 3 2010,2011
#      procesa los modelo 2010, 2011, ...
# perl Porticos.pl 3 2010,2011 join1
#      Se sube a moodle el último modelo QUE INCLUYE TODOS los anteriores.
#      Esta opción puede dar lugar a muchas ambiguedades. Por ejemplo, en
#      "perl Porticos.pl 3 2010,2017 join1" (viga AA y EE) los diagramas de
#      V son idénticos, pero
#      "perl Porticos.pl 3 2010,2011 join1" (viga AA, EA) si es una opción
#      aceptable, pues los diagramas son 'claramente' distintos
# perl Porticos.pl 3 2010,2011 join2
#      Se sube a moodle un h5p en el cual cada nivel es de uno de los modelos
#      De este modo se evita la ambiguedad anterior
# perl Porticos.pl 3 2010,2011 join1
# perl Porticos.pl 3 2010,2012 join1
# perl Porticos.pl -3 2011,2012 join2
#      Union tipo2 de los modelos tipo1 2010,2011 + 2010,2012. Con la opción -3
#      no se regeneran las imagenes de 2011 y 2012, que se han creado con
#      'join1', que con la última linea se unen con la opción 'join2'
# perl Porticos.pl  3  5212,5213,5211,5210,5220,5230 join2
# perl Porticos.pl  3  5210,5240 join1
# perl Porticos.pl -3  5212,5213,5211,5210,5220,5230,5240 join2
#
# perl Porticos.pl  3  1120,1121,1125,1155 join2
# perl Porticos.pl  3  1155,1135 join1
# perl Porticos.pl -3  1120,1121,1125,1155,1135 join2
#


use Term::ANSIColor;
use Cwd qw(cwd);
my $dir = cwd;

# Declaración de variables globales del script
our ($joinH5P, $NP_1, $NP_2, $NP_join2);  # Se leen y modifican dentro de procesar_opcion_3. Se declaran globales para que persistan en foreach. Al no usar strict no creo que sea necesario
                                         

#------------------------------------------------------------------------------
dondeEstoy();
titulo ("Estoy en $dondeestoy \n"); 
#------------------------------------------------------------------------------


$opcion=1; # Solo se procesa fichero maple=>crear cuestionarios semanales
$opcion=2; # Idem+se generan iconos gif
# $opcion=2.6 idem para dyd
$opcion=3; # Se crean ejercicios h5p
$opcion=4; # Idem+Se suben a la base de datos los ejercicios multichoice
#$opcion=6; # Idem+Se suben a la base de datos los ejercicios dd
#$opcion=-6; # Idem, sin volver a procesar 2
# idem para -3, -4,-5,-6,-7
#$opcion=5; # Idem+Se suben a la base de datos los ejercicios h5p
#    $opcion=7; # Idem+Se genera poster de resultados
#    $opcion=3;
#$opcion=8; # Se procesas solo el primer modelo
#           # Se utiliza en definidión de modelos y para poster de modelos
if(defined $ARGV[0]){
    $opcion=$ARGV[0];
}

$modelos=qw (70);
if(defined $ARGV[1]){
    $modelos=$ARGV[1];
}

system ("clear");
titulo("Se procesa InitServidor.sh");

system ("cd maple/server; sh InitServidor.sh");
if ($opcion==0) {exit(0);};


foreach $NP (split(',',$modelos)) {#};

    preparar_lanzar_y_recuperarSalida_maple();
   
    if ($opcion>=1) {
	preparar_ficheros_tex();
    } if ($opcion>=2) {
	generar_imagenes_gif();
    # ------Se generan xls para E4.pl y ficheros H5P.pl-------------------------
    } if (abs($opcion)==3  || abs($opcion)==4 || abs($opcion)==6  ||
	  abs($opcion)==46 || abs($opcion)==64){
	generar_datos_dragdrop();
    } if (abs($opcion)==3 ){
	compilar_ejercicios_h5p();
    } if ($opcion==4 || $opcion==46 || $opcion==64){
	subir_preguntas_multichoice();
    } if ($opcion==5){	
	subir_ejercicios_h5p();
    } if (abs($opcion)==6 || $opcion==46 || $opcion==64){	
	subir_preguntas_dragdrop();
    }  if (abs($opcion)==7) {
	generar_poster_pdf();
    }
    next; # Se procesan hasta los dibujos para incluir en preguntas. Comentar esta linea para continuar
    system ("rm -rf $Porticos$NP; mkdir $Porticos$NP ;".
	    "mv /tmp/tmp $Porticos$NP;".
	    "mv $Porticos$NP/tmp $Porticos$NP/tex;".
	    "cd $Porticos$NP;".
	    "mkdir drag_drop;".
	    "perl ../src/tex2gif.pl $NP;".
	    "perl ../src/drag_drop.pl $NP;".
	    "perl ../src/H5P.pl $NP;".
	    "cd ..;".
	    "perl  ./180916-consultas_basicas/E4/E4.pl $Porticos$NP/multichoice.xls;".
	    "for i in $Porticos$NP/h5p/H*xls; do ".
	    "echo ./180916-consultas_basicas/H5P/H5P.pl; echo \$i;".
	    "perl  ./180916-consultas_basicas/H5P/H5P.pl \$i;done"
	);
    exit(2);
    #-------------------------Poster--------------------------------------------
    system ("cd $Porticos$NP;".
	    "cp -r ../src/poster ./;".
	    "cd poster;".
	    "perl poster.pl;".
	    "cp poster.pdf ../;".
	    "cd ..; rm -r poster;");
}

sub preparar_lanzar_y_recuperarSalida_maple {
    $Porticos = "newPorticos_";
    
    #------------------------Se modifica el fichero de Maple--------------------
    titulo("Se prepara newPortico.mws > aux.mws para procesar $NP");
    $dirMaple = "$dir/maple";
    
    system ("cat $dirMaple/newPortico.mws| sed 's/NP:=.*/NP:=$NP;/' > ".
            "$dirMaple/aux.mws");
            
    if ($opcion == 8) {
        system ("cat $dirMaple/aux.mws | sed 's/nops(variacionesP)/1/' >".
                "$dirMaple/aux1.mws; mv $dirMaple/aux1.mws $dirMaple/aux.mws");
        #exit(0);
    }
    
    #-------------------------Maple en VirtualBox-------------------------------
    titulo("Se hace sh rmTmpMimapleScp.sh aux.mws");
    
    system ("ssh localhost -p 2222 -oKexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa 'cd vigas1vano; pwd;".
            "grep ^NP aux.mws;  ".
            "sh rmTmpMimapleScp.sh aux.mws;".
            "echo 'El error anterior, lost connection, es intrascendente';".
            "'");
            
    #-------------------------Se copian los ficheros de VirtualBox--------------
    titulo("Se copian los ficheros de VirtualBox a /tmp/tmp");
    
    system ("rm -rf /tmp/tmp;".
            "scp -r  -P 2222 -oKexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa localhost:/tmp /tmp");
}

sub preparar_ficheros_tex {
    #-------------------------Se procesan resultados de Maple-------------------
    titulo ("1. Se borra/crea $Porticos$NP\n".
        "   Se mueve /tmp/tmp a $Porticos$NP/tex");
    system ("rm -rf $Porticos$NP; mkdir $Porticos$NP ;".
        "mv /tmp/tmp $Porticos$NP;".
        "mv $Porticos$NP/tmp $Porticos$NP/tex;".
        "rm -f $Porticos$NP/tex/.X64-lock;".
            "cd $Porticos$NP; perl ../src/postGrifos.pl");
}

sub generar_imagenes_gif {
    # ------Se procesan los dibujos para incluir en preguntas-------------------
    $dd="mc";    if ($opcion==6 || $opcion==2.6) {$dd="dd"};
    titulo ("2. Se crea $Porticos$NP/drag_drop\n".
        "   Se hace tex2gif.pl $dd");
    system ("cd $Porticos$NP;".
        "mkdir drag_drop;".
        "perl ../src/tex2gif.pl $dd  $dondeestoy;");
}



sub generar_datos_dragdrop {
    # ------Se generan xls para E4.pl y ficheros H5P.pl-------------------------
    titulo ("3. Se hace perl ../src/drag_drop.pl $NP\n".
        "   perl ../src/drag_drop.pl $NP dd;\n");
    system ("cd $Porticos$NP;".
        "perl ../src/drag_drop.pl $NP;".
        "perl ../src/drag_drop.pl $NP dd;");
}

sub compilar_ejercicios_h5p {
    if(defined $ARGV[2]){
	$joinH5P=$ARGV[2];
    }
    if ($NP_1 ne undef &&
	$joinH5P eq 'join1') {
	# Una argucia para juntar varios modelos
	# Escribir Porticos.pl 3 2050,2060,..
	# separados por comas y sin espacios
	#
	# Simplemente se van copiando los resultados 'anteriores' sobre el
	# último directorio incrementando el valor de los ficheros de
	# imagen (y cambiando su 'id') y en el H5P2moodle.pl se hace
	# sobre esté último directorio (realmente se va haciendo sobre
	# todos los de la lista, lo que hace lento el proceso, pero la
	# velocidad no es un prioridad). 
	print "\nmodelo anterior=$NP_1     pwd=$PWD\n";
	$NP_2=$NP_2+1;
	print ("xxxxxxxxxxxxxxxxxxx;\npwd; ls; pwd;".
	       "cd newPorticos_$NP_1/drag_drop;".
	       "ls *svg;".
	       "j=20000;".
	       "for i in *gif; do ".
	       "j=`expr \$j + 1`;".
	       "k=`echo \$i | sed 's/[0-9]*_/'\$j'_/'`;".
	       "cp \$i ../../newPorticos_$NP/drag_drop/\$k; done");
	system ("pwd; ls; pwd;".
		"cd newPorticos_$NP_1/drag_drop;".
		"ls *svg;".
		"j=20000;".
		"for i in *gif; do ".
		#"j=`expr \$j + 1`;".
		"l=`echo \$i | sed 's/_.*//'`;".
		"lj=`expr \$j + \$l`;".
		"k=`echo \$i | sed 's/[0-9]*_/'\$lj'_/'`;".
		"cp \$i ../../newPorticos_$NP/drag_drop/\$k; done");
	#"cp \$i ../../newPorticos_$NP/drag_drop/$NP_2\$i; done");
	#	    exit (2);
	#j=2000; for i in *gif;do j=`expr $j + 1`; k=`echo $i | sed 's/[0-9]*_/'$j'_/'`; echo $i $j $k; done
    }
    #else {$NP_2=$NP_1}
    # Con la opcion join2 es absurdo procesar H5P2moodle.pl pues los
    # resultados se reescribiran, pero la eficacia no es un valor 
    titulo ("3. Se hace: \nperl ../src/H5P.pl $NP".
	    "   perl ../src/H5P2moodle.pl $NP");
    system ("cd $Porticos$NP;".
	    "perl ../src/H5P.pl $NP;".
	    "perl ../src/H5P2moodle.pl $NP");
    if ($joinH5P eq 'join2' ) {
	if ($NP_join2 ne undef) {
	    $NP_join2="$NP_join2,$NP";
	    titulo ("3. Se hace:  perl src/H5P22moodle.pl $NP_join2");
	    #system ("cd $Porticos$NP;".
	    #	"perl ../src/H5P22moodle.pl $NP_join2");
	    system ("pwd; perl src/H5P22moodle.pl $NP_join2");
	    titulo ("resultados en auxBorrame y curso de moodle h5p");
	} else {
	    $NP_join2="$NP";   #Valor inicial
	}
	
    }
    $NP_1=$NP;
}

sub subir_preguntas_multichoice {
    titulo ("4. Se suben a la base de datos de moodle los multichoice\n".
	    "   Se hace perl ./180916-consultas_basicas/E4/E4.pl ".
	    "$Porticos$NP/multichoice.xls;");
    system ("perl  ./180916-consultas_basicas/E4/E4.pl ".
	    "$Porticos$NP/multichoice.xls;");
    titulo ("Para que se vea el cuestionario hay que crear otro\n".
	    "Queda algún fleco por programar");
    titulo ("Para que se vea el cuestionario hay que crear otro\n".
	    "Queda algún fleco por programar");
}

sub subir_ejercicios_h5p {
    titulo ("5. Se suben a la base de datos H5P\n".
	    "   Se hace perl ./180916-consultas_basicas/H5P/H5P.pl \$i");
    system ("for i in $Porticos$NP/h5p/H*xls; do ".
	    "echo ./180916-consultas_basicas/H5P/H5P.pl; echo \$i;".
	    "perl  ./180916-consultas_basicas/H5P/H5P.pl \$i;done");
}

sub subir_preguntas_dragdrop {
    titulo ("6. Se suben a la base de datos de moodle los drag&drop\n".
	    "   Se hace perl ./180916-consultas_basicas/E4/E4.pl ".
	    "$Porticos$NP/dragdrop.xls;");
    system ("perl  ./180916-consultas_basicas/E4/E4.pl ".
	    "$Porticos$NP/dragdrop.xls;");
    titulo ("Para que se vea el cuestionario hay que crear otro\n".
	    "Queda algún fleco por programar");
    titulo ("Para que se vea el cuestionario hay que crear otro\n".
	    "Queda algún fleco por programar");
    titulo ("Mas bien parece que es un problema con el cache de moodle");
}

sub generar_poster_pdf {
    $tituloPoster="";
    if(defined $ARGV[2]){
	$tituloPoster=$ARGV[2];
    }
    system ("cd $Porticos$NP;".
	    "cp -r ../src/poster ./;".
	    "cd poster;".
	    "perl poster.pl $tituloPoster;".
	    "cp poster.pdf ../;".
	    "cd ..; rm -r poster;");
}


sub titulo ($txt) {
    print "\n";
    print color('bold');
    print "---------------------------------------------------------------------\n";
    print "$0\n";
    print "$_[0]\n";
    print "---------------------------------------------------------------------\n";
    print "\n";
    print color('reset');
}


sub dondeEstoy () {
    $dondeestoy=`uname -a`;
    if ($dondeestoy=~"4.9") {
	$dondeestoy="escuela";}
    else{
	$dondeestoy="hp-azul";}
}
