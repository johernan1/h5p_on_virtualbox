#!/usr/bin/perl
#
use File::Path qw(make_path remove_tree);
use Digest::SHA1;
use File::Copy;

print "Incluyendo fichero: mdl_files_Insert\n";

sub mdl_files_Insert{
    my $path=shift;
    my $filename=shift;
    my $contextid=shift;
    my $component=shift;
    my $filearea=shift;
    my $itemid=shift;
    my $filearea2=shift || '';

    my $Sub="mdl_files_Insert";
    iniSub($Sub);
        
    printT "itemid.............$itemid\n";
    printT "contextid.............$contextid\n";
    ##########################################################################
    #### Se obtiene el sha1 del fichero y se graba en el lugar de moodledata

    my $fh;
    printT "$Sub: $path/$filename\n";
    open $fh, "$path/$filename" || 
	die "$Sub. No se puede abrir $path/$filename";
    my $sha1 = Digest::SHA1->new;
    $sha1->addfile($fh);
    $shaFichero=$sha1->hexdigest;
    printT "sha1($path/$filename->\n";printT "..........$shaFichero\n";
  #exit;
  
    $dir1=substr($shaFichero,0,2);
    $dir2=substr($shaFichero,2,2);
    printT ("$dir1...$dir2... /var/lib/moodle/filedir/\n");

    printT ("ahora se comprueba si el sisema es linux o msdos: $^O\n");
    if ($^O eq 'linux') {
	printT("Estamos en LINUX\n");
	foreach("/var/lib/moodle/filedir", "/var/www/moodledata/filedir"){
	    if (-d $_) {$DIRMOODLE=$_;}}
	    
	(-d $DIRMOODLE) || die "$sub. No se encuentra el directorio de datos de moodle:$DIRMOODLE\n";
	
#	if (-d $DIRMOODLE) 
#    $DIRMOODLE="/var/lib/moodle/filedir";
    ### Se cambian los permisos del directorio $DIRMOODLE
    ### tomando una pequeña precaución: se verifica que $DIRMOODLE contiene 'fildir'
    print seccion "";
    print seccion "OJO...OJO...OJO";
    print seccion "Anadir 'johernan ALL=(ALL) NOPASSWD:/bin/chmod' a sudoers";
    print seccion "";
    if($DIRMOODLE=~/filedir/) {
	system("sudo chmod -R 777 $DIRMOODLE/*");
	make_path ("$DIRMOODLE/$dir1/$dir2");
        pausa 	"Se intenta crear la carpeta: $DIRMOODLE/$dir1/$dir2\n";

	system "#ls -l $DIRMOODLE;
                cp $path/$filename $DIRMOODLE/$dir1/$dir2/$shaFichero;
                chmod -R 777 $DIRMOODLE/$dir1;
                #echo '---------';
                #ls -l $DIRMOODLE;
           ";    
    }
    else { Pausa ("$Sub: la variable DIRMOODLE ($DIRMOODLE) debe contener 'filedr'",
	       "De otro modo se estarían cambiando permisos de un fichero 'descoocido'"); 
	   die;}

    }
    else {
	printT("Estamos en MSDOS");
	$DIRMOODLE="C:\\Documents and Settings\\etsam\\Escritorio\\moodle2.2\\server\\moodledata\\filedir";
	make_path ("$DIRMOODLE/$dir1/$dir2"); 
	copy ("$path\\$filename", "$DIRMOODLE\\$dir1\\$dir2\\$shaFichero");
	##pausa("¿Se ha mk $DIRMOODLE/$dir1/$dir2?");
	$aux="copy $path\\$filename $DIRMOODLE\\$dir1\\$dir2\\$shaFichero";
	##system($aux);
	##pausa("¿Se ha  $aux");
    }
  
    ##########################################################################
    ### Ahora el "path"
    my $filepath="/";
    my $sha1_ = Digest::SHA1->new;
    my $pathname;
    if ($filearea2 eq '') { # Dibujos en question 
	$pathname="/$contextid/$component/$filearea/$itemid/$filename";
    } else { # Dibujos hvp
	$pathname="/$contextid/$component/$itemid/$filearea2/$filename";
    }
    printT "pathname->$pathname->sha1->\n";
    $sha1_->add($pathname);
    my $pathnamehash=$sha1_->hexdigest;
    printT "..........$pathnamehash\n";
    printT "component..........$component\n";
    printT "filearea...........$filearea\n";
    printT "itemid.............$itemid\n";
    #exit;
#while(siono("pulsar y para continuar",'si','no') eq 'si') {}; 
    my $filesize= -s "$path/$filename";

    my $consulta="delete from mdl_files where pathnamehash='$pathnamehash'";
    $dbh->do($consulta);
    #pausa "$Sub: $consulta\n";

    $consulta="insert into mdl_files (contenthash,contextid,component,filearea,itemid,filepath,filename,pathnamehash,filesize,timecreated,timemodified) VALUES ('$shaFichero',$contextid,'$component','$filearea','$itemid','$filepath','$filename','$pathnamehash',$filesize,1,1)";
    #pausa "$Sub: $consulta\n";
    #printT "$consulta\n";  

    $dbh->do($consulta)||die "$consulta";

    finSub($Sub);
}
