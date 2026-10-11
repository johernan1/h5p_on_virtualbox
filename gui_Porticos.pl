#!/usr/bin/env perl
use strict;
use warnings;
use Tk;
use Term::ANSIColor;
use Cwd qw(cwd);

my $dir = cwd();

# Variables globales que persisten a lo largo de las ejecuciones
our ($joinH5P,$NP_1, $NP_2,$NP_join2);
our ($opcion, $NP,$Porticos, $dirMaple,$dd, $dondeestoy,$tituloPoster);

# --- INTERFAZ GRÁFICA (Tk) ---
my $mw = MainWindow->new;
$mw->title("Gestor Pórticos - Interfaz Gráfica");
$mw->geometry("500x550");

# Variables vinculadas a la GUI
my $modelos_entry = "70";
my $extra_entry   = "";

# Configuración de subrutinas a ejecutar (Checkboxes)
my %ejecutar = (
    opcion_1        => 1, # [x] Preparar ficheros TeX
    opcion_2        => 1, # [x] Generar imágenes GIF
    opcion_dragdrop => 0, # [ ] Generar datos Drag&Drop
    opcion_3        => 0, # [ ] Compilar ejercicios H5P
    opcion_4        => 0, # [ ] Subir preguntas MultiChoice
    opcion_5        => 0, # [ ] Subir ejercicios H5P
    opcion_6        => 0, # [ ] Subir preguntas Drag&Drop
    opcion_7        => 0, # [ ] Generar póster PDF
);

# --- ENTRADAS DE PARÁMETROS ---
my $f_input =$mw->Frame->pack(-fill => 'x', -padx => 10, -pady => 10);

$f_input->Label(-text => "Modelos (separados por coma):", -anchor => 'w')->pack(-fill => 'x');
#$f_input->Entry(-textvariable => \$modelos_entry)->pack(-fill => 'x', -pady => [0, 5]);
# 1. Crear un frame contenedor para agrupar la caja de texto y el botón
my $f_entry_btn = $f_input->Frame()->pack(-fill => 'x', -pady => [0, 5]);

# 2. Empaquetar la entrada a la izquierda ocupando el espacio disponible
$f_entry_btn->Entry(
    -textvariable => \$modelos_entry
)->pack(-side => 'left', -expand => 1, -fill => 'x');

# 3. Empaquetar el botón a la derecha
$f_entry_btn->Button(
    -text    => 'Listar NP',
    -command => sub {
        my $cmd = "grep 'NP=[0-9]*' maple/newPortico.mws";
        my $cmd = "sed -n 's/.*NP=\\([0-9]*\\).*/\\1/p' maple/newPortico.mws | sort -n -u";

        # Opción A: Abrir una terminal xterm para ver la lista y pausar al terminar
        system("xterm -e \"$cmd; echo ''; read -p 'Pulsa ENTER para cerrar...'\" &");
    }
)->pack(-side => 'right', -padx => [5, 0]);

$f_input->Label(-text => "Opciones adicionales / Join / Título Póster:", -anchor => 'w')->pack(-fill => 'x');
$f_input->Entry(-textvariable => \$extra_entry)->pack(-fill => 'x');

# --- CHECKBOXES DE TAREAS ---
my $f_checks =$mw->Labelframe(-text => " Tareas a ejecutar ", -padx => 10, -pady => 10);
$f_checks->pack(-fill => 'both', -expand => 1, -padx => 10, -pady => 5);

#$f_checks->Checkbutton(-text => "1. Preparar ficheros TeX",            -variable => \$ejecutar{opcion_1})->pack(-anchor => 'w');
# --- MODIFICADO: Fila 1 con Checkbutton y Botón a la derecha ---
my $f_fila1 = $f_checks->Frame->pack(-fill => 'x', -anchor => 'w');

$f_fila1->Checkbutton(
    -text     => "1. Preparar ficheros TeX",
    -variable => \$ejecutar{opcion_1}
)->pack(-side => 'left');

$f_fila1->Button(
    -text    => "Ver .ps",
    -command => \&listar_archivos_ps
)->pack(-side => 'right', -padx => 10);
# --- FIN MODIFICACIÓN FILA 1 ---
$f_checks->Checkbutton(-text => "2. Generar imágenes GIF",            -variable => \$ejecutar{opcion_2})->pack(-anchor => 'w');
$f_checks->Checkbutton(-text => "3. Generar datos Drag & Drop",        -variable => \$ejecutar{opcion_dragdrop})->pack(-anchor => 'w');
$f_checks->Checkbutton(-text => "4. Compilar ejercicios H5P",          -variable => \$ejecutar{opcion_3})->pack(-anchor => 'w');
$f_checks->Checkbutton(-text => "5. Subir preguntas MultiChoice (E4)", -variable => \$ejecutar{opcion_4})->pack(-anchor => 'w');
$f_checks->Checkbutton(-text => "6. Subir ejercicios H5P",            -variable => \$ejecutar{opcion_5})->pack(-anchor => 'w');
$f_checks->Checkbutton(-text => "7. Subir preguntas Drag & Drop",      -variable => \$ejecutar{opcion_6})->pack(-anchor => 'w');
$f_checks->Checkbutton(-text => "8. Generar Póster PDF",               -variable => \$ejecutar{opcion_7})->pack(-anchor => 'w');

# --- BOTÓN LANZAR ---
$mw->Button(
    -text    => "LANZAR",
    -bg      => "#28a745",
    -fg      => "white",
    -font    => ['Helvetica', 12, 'bold'],
    -command => \&ejecutar_proceso
)->pack(-fill => 'x', -padx => 10, -pady => 10);

MainLoop();

# --- LÓGICA DE EJECUCIÓN ---
sub ejecutar_proceso {
    dondeEstoy();
    titulo("Estoy en $dondeestoy \n");

    system("clear");
    titulo("Se procesa InitServidor.sh");
    system("cd maple/server; sh InitServidor.sh");

    # Configurar parámetros desde la GUI
    $joinH5P     =$extra_entry;
    $tituloPoster =$extra_entry;

    my @modelos = split(',', $modelos_entry);

    foreach $NP (@modelos) {
        preparar_lanzar_y_recuperarSalida_maple();

        # Invocación directa según selección en la GUI
        preparar_ficheros_tex()         if $ejecutar{opcion_1};
        generar_imagenes_gif()          if $ejecutar{opcion_2};
        generar_datos_dragdrop()        if $ejecutar{opcion_dragdrop};
        compilar_ejercicios_h5p()       if $ejecutar{opcion_3};
        subir_preguntas_multichoice()   if $ejecutar{opcion_4};
        subir_ejercicios_h5p()          if $ejecutar{opcion_5};
        subir_preguntas_dragdrop()      if $ejecutar{opcion_6};
        generar_poster_pdf()            if $ejecutar{opcion_7};
    }

    titulo("Proceso completado con éxito");
}

# --- SUBRUTINAS AUXILIARES Y OPERATIVAS ---

sub preparar_lanzar_y_recuperarSalida_maple {
    $Porticos = "newPorticos_";
    
    #------------------------Se modifica el fichero de Maple--------------------
    titulo("Se prepara newPortico.mws > aux.mws para procesar $NP");
    $dirMaple = "$dir/maple";
    
    system("cat $dirMaple/newPortico.mws| sed 's/NP:=.*/NP:=$NP;/' >$dirMaple/aux.mws");
    
    #-------------------------Maple en VirtualBox-------------------------------
    titulo("Se hace sh rmTmpMimapleScp.sh aux.mws");
    system("ssh localhost -p 2222 -oKexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa 'cd vigas1vano; pwd; grep ^NP aux.mws; sh rmTmpMimapleScp.sh aux.mws; echo \"El error anterior, lost connection, es intrascendente\";'");
            
    #-------------------------Se copian los ficheros de VirtualBox--------------
    titulo("Se copian los ficheros de VirtualBox a /tmp/tmp");
    system("rm -rf /tmp/tmp; scp -r -P 2222 -oKexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa localhost:/tmp /tmp");
}

sub preparar_ficheros_tex {
    titulo("1. Se borra/crea $Porticos$NP\n   Se mueve /tmp/tmp a $Porticos$NP/tex");
    system("rm -rf $Porticos$NP; mkdir $Porticos$NP; mv /tmp/tmp $Porticos$NP; mv $Porticos$NP/tmp $Porticos$NP/tex; rm -f $Porticos$NP/tex/.X64-lock; cd $Porticos$NP; perl ../src/postGrifos.pl");
}

sub generar_imagenes_gif {
    $dd = "mc";
    titulo("2. Se crea $Porticos$NP/drag_drop\n   Se hace tex2gif.pl $dd $dondeestoy");
    system("cd $Porticos$NP; mkdir drag_drop; perl ../src/tex2gif.pl $dd $dondeestoy;");
}

sub generar_datos_dragdrop {
    titulo("3. Se hace perl ../src/drag_drop.pl $NP\n   perl ../src/drag_drop.pl $NP dd;\n");
    system("cd $Porticos$NP; perl ../src/drag_drop.pl $NP; perl ../src/drag_drop.pl $NP dd;");
}

sub compilar_ejercicios_h5p {
    if (defined $NP_1 &&$joinH5P eq 'join1') {
        print "\nmodelo anterior=$NP_1     pwd=$dir\n";
        $NP_2 = $NP_2 + 1 if defined$NP_2;
        system("pwd; ls; pwd; cd newPorticos_$NP_1/drag_drop; ls *svg; j=20000; for i in *gif; do l=`echo \$i | sed 's/_.*//'`; lj=`expr \$j + \$l`; k=`echo \$i | sed 's/[0-9]*_/'\$lj'_/'`; cp \$i ../../newPorticos_$NP/drag_drop/\$k; done");
    }

    titulo("3. Se hace: \nperl ../src/H5P.pl $NP   perl ../src/H5P2moodle.pl $NP");
    system("cd $Porticos$NP; perl ../src/H5P.pl $NP; perl ../src/H5P2moodle.pl $NP");

    if ($joinH5P eq 'join2') {
        if (defined $NP_join2) {$NP_join2 = "$NP_join2,$NP";
            titulo("3. Se hace:  perl src/H5P22moodle.pl $NP_join2");
            system("pwd; perl src/H5P22moodle.pl $NP_join2");
            titulo("resultados en auxBorrame y curso de moodle h5p");
        } else {
            $NP_join2 = "$NP";
        }
    }
    $NP_1 =$NP;
}

sub subir_preguntas_multichoice {
    titulo("4. Se suben a la base de datos de moodle los multichoice\n   Se hace perl ./180916-consultas_basicas/E4/E4.pl $Porticos$NP/multichoice.xls;");
    system("perl ./180916-consultas_basicas/E4/E4.pl $Porticos$NP/multichoice.xls;");
    titulo("Para que se vea el cuestionario hay que crear otro\nQueda algún fleco por programar");
}

sub subir_ejercicios_h5p {
    titulo("5. Se suben a la base de datos H5P\n   Se hace perl ./180916-consultas_basicas/H5P/H5P.pl \$i");
    system("for i in $Porticos$NP/h5p/H*xls; do echo ./180916-consultas_basicas/H5P/H5P.pl; echo \$i; perl ./180916-consultas_basicas/H5P/H5P.pl \$i; done");
}

sub subir_preguntas_dragdrop {
    titulo("6. Se suben a la base de datos de moodle los drag&drop\n   Se hace perl ./180916-consultas_basicas/E4/E4.pl $Porticos$NP/dragdrop.xls;");
    system("perl ./180916-consultas_basicas/E4/E4.pl $Porticos$NP/dragdrop.xls;");
    titulo("Para que se vea el cuestionario hay que crear otro\nQueda algún fleco por programar");
}

sub generar_poster_pdf {
    system("cd $Porticos$NP; cp -r ../src/poster ./; cd poster; perl poster.pl $tituloPoster; cp poster.pdf ../; cd ..; rm -r poster;");
}

sub listar_archivos_ps {
        # Extraer el primer modelo si hay varios separados por comas
        my ($primer_modelo) = split(',',$modelos_entry);
        $primer_modelo =~ s/^\s+\vert{}\s+$//g; # Limpiar espacios
        
        my $ruta_tex = "newPorticos_${primer_modelo}/tex";
        
        my $cmd_bash = "ls -la ${ruta_tex}/*ps 2>/dev/null || echo 'No se encontraron archivos .ps o no existe el directorio.'; echo ''; read -p 'Pulsa ENTER para cerrar...'";
        #my $cmd_bash = "{ echo '--- Lista de archivos ---'; ls -la ${ruta_tex}/*ps 2>/dev/null; echo '--- Total de archivos .ps ---'; num_files=\$(ls -1 ${ruta_tex}/*ps 2>/dev/null | wc -l); if [ \$num_files -gt 0 ]; then echo \$num_files; else echo 'No se encontraron archivos .ps o no existe el directorio.'; fi; } ; echo ''; read -p 'Pulsa ENTER para cerrar...'";
        #my $cmd_bash = "{ echo '--- Lista de archivos ---'; ls -la ${ruta_tex}/*ps 2>/dev/null; echo '--- Total de archivos .ps ---'; num_files=\$(ls -1 ${ruta_tex}/*ps 2>/dev/null | wc -l); if [ \"\$num_files\" -gt 0 ]; then echo \$num_files; else echo 'No se encontraron archivos .ps o no existe el directorio.'; fi; } ; echo ''; read -p 'Pulsa ENTER para cerrar...'";

        # Seleccionar la primera terminal disponible en el sistema para evitar abrir dos
        my $term = `which x-terminal-emulator gnome-terminal xterm 2>/dev/null | head -n 1`;
        chomp $term;

        if ($term) {
            system("$term -e bash -c \"$cmd_bash\" &");
        } else {
            print "\n[ERROR] No se encontro ningún emulador de terminal instalado (x-terminal-emulator, gnome-terminal, xterm).\n";
        }
}

sub titulo {
    my ($txt) = @_;
    print "\n";
    print color('bold');
    print "---------------------------------------------------------------------\n";
    print "$0\n";
    print "$txt\n";
    print "---------------------------------------------------------------------\n";
    print color('reset');
}

sub dondeEstoy {
    $dondeestoy = `uname -a`;
    if ($dondeestoy =~ /4\.9/) {$dondeestoy = "escuela";
    } else {
        $dondeestoy = "hp-azul";
    }
}
