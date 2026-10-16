#!/usr/bin/env perl
use strict;
use warnings;
use Tk;
use Term::ANSIColor;
use Cwd qw(cwd);
require "./gui_opciones.pl";

my $dir = cwd();
# ---------------------------------------------------------------------
# Variables globales que persisten a lo largo de las ejecuciones
our ($joinH5P,$NP_1, $NP_2,$NP_join2);
our ($opcion, $NP,$Porticos, $dirMaple,$dd, $dondeestoy,$tituloPoster);
our $NOMBRE_VM       ="debian vigas1vanoMaple";
our $SSH_COMMON_OPTS = " -o ConnectTimeout=2 -o ServerAliveInterval=2 -o ServerAliveCountMax=1 -o KexAlgorithms=+diffie-hellman-group1-sha1";
our $SSH_LEGACY_OPTS = " -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa";
our $SSH_BATCH_OPTS  = " -n -o BatchMode=yes";

# Variables globales de las opciones y valores por efec 
our ($opcionC, $opcion_tex, $textoAmpliado);
our ($escal, $escalP, $escalq, $escalM);
our ($perfiles, $comprobaciones);

$opcionC       = 1;
$opcion_tex    = 1;
$textoAmpliado = 1;
$escal         = "0.15";
$escalP        = "0.008";
$escalq        = "0.01";
$escalM        = "1";
$perfiles      = 1;
$comprobaciones= 0;
# ---------------------------------------------------------------------

# --- INTERFAZ GRÁFICA (Tk) ---
my $mw = MainWindow->new;
$mw->title("Gestor Pórticos - Interfaz Gráfica");
$mw->geometry("500x650");

# Variables vinculadas a la GUI
my $modelos_entry = "2001";
my $extra_entry   = "";

# Configuración de subrutinas a ejecutar (Checkboxes)
my %ejecutar = (
    opcion_1        => 0, # [ ] Preparar ficheros TeX
    opcion_2        => 0, # [ ] Generar imágenes GIF
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
        #my $cmd = "grep 'NP=[0-9]*' maple/newPortico.mws";
        my $cmd = "sed -n 's/.*NP=\\([0-9]*\\).*/\\1/p' maple/newPortico.mws | sort -n -u";

        # Opción A: Abrir una terminal xterm para ver la lista y pausar al terminar
        system("xterm -e \"$cmd; echo ''; read -p 'Pulsa ENTER para cerrar...'\" &");
    }
)->pack(-side => 'right', -padx => [5, 0]);

$f_input->Label(-text => "Opciones adicionales / Join / Título Póster:", -anchor => 'w')->pack(-fill => 'x');
$f_input->Entry(-textvariable => \$extra_entry)->pack(-fill => 'x');

# --- OPCIONES
crear_panel_opciones_extra($mw);

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
    
    my $cmd0="(cd maple/server; sh InitServidor.sh '$NOMBRE_VM'  '$SSH_COMMON_OPTS' '$SSH_LEGACY_OPTS' '$SSH_BATCH_OPTS')";
    #my $cmd0="(cd maple/server; sh InitServidor.sh )";
    ejecutar_comando ("($cmd0)");
	

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
sub modificar_variable_en_aux_mws {
    my ($nombre, $valor) = @_;

    ejecutar_comando("(sed -i -E 's/(".$nombre."[[:space:]]*:=)[^;]*;/\\1$valor;/g' $dirMaple/aux.mws)");
}
sub preparar_lanzar_y_recuperarSalida_maple {
    $Porticos = "newPorticos_";

    #------------------------Se modifica el fichero de Maple--------------------
    # El procedimiento para 'pasar' las opciones (burdo pero simple)
    # es cambiar las variables del fichero newPortico.mws (el codigo
    # original 'cutre' pero 'robusto' y 'chequeado') que se reescribe como
    # aux.mws. Finalmente no se lanza newPortico.mws sino aux.mws
    titulo("Se prepara newPortico.mws > aux.mws para procesar $NP");
    $dirMaple = "$dir/maple";
    
    ejecutar_comando("(sed 's/NP:=.*/NP:=$NP;/'< $dirMaple/newPortico.mws > $dirMaple/aux.mws)");
    modificar_variable_en_aux_mws("opcionC",       $opcionC);
    modificar_variable_en_aux_mws("opcion",        $opcion_tex+1); # No se definio como bool. Toma valores 1 o 2 ¿?
    modificar_variable_en_aux_mws("textoAmpliado", $textoAmpliado);
    modificar_variable_en_aux_mws("escal",         $escal);
    modificar_variable_en_aux_mws("escalP",        $escalP);
    modificar_variable_en_aux_mws("escalq",        $escalq);
    modificar_variable_en_aux_mws("escalM",        $escalM);
    my $ER="[".$perfiles.",".$comprobaciones."]";
    modificar_variable_en_aux_mws("ER",            $ER);
    
    #-------------------------Maple en VirtualBox-------------------------------
    titulo("Se hace sh rmTmpMimapleScp.sh aux.mws");
    my $puerto = get_vm_port("'$NOMBRE_VM'");
    ejecutar_comando("ssh localhost -p $puerto $SSH_COMMON_OPTS $SSH_LEGACY_OPTS 'cd vigas1vano; pwd; grep ^NP aux.mws; sh rmTmpMimapleScp.sh aux.mws'");
    #print "El -posible- error anterior, lost connection, es intrascendente";
            
    #-------------------------Se copian los ficheros de VirtualBox--------------
    titulo("Se copian los ficheros de VirtualBox a /tmp/\$USER/tmp");
    ejecutar_comando("rm -rf /tmp/\$USER/tmp");
    ejecutar_comando("mkdir -p /tmp/\$USER/tmp");
    ejecutar_comando("scp -r -P $puerto $SSH_COMMON_OPTS $SSH_LEGACY_OPTS localhost:/tmp/[!.]* /tmp/\$USER/tmp/");
}

sub preparar_ficheros_tex {
    titulo("1. Se borra/crea $Porticos$NP\n   Se mueve /tmp/\$USER/tmp a $Porticos$NP/tex");
    #system("rm -rf $Porticos$NP; mkdir $Porticos$NP; mv /tmp/tmp $Porticos$NP; mv $Porticos$NP/tmp $Porticos$NP/tex; rm -f $Porticos$NP/tex/.X64-lock; cd $Porticos$NP; perl ../src/postGrifos.pl");
    ejecutar_comando("rm -rf $Porticos$NP");
    ejecutar_comando("mkdir $Porticos$NP");
    ejecutar_comando("mv /tmp/\$USER/tmp $Porticos$NP");
    ejecutar_comando("mv $Porticos$NP/tmp $Porticos$NP/tex");
    #rm -f $Porticos$NP/tex/.X64-lock;
    ejecutar_comando("cd $Porticos$NP; perl ../src/postGrifos.pl");
    ejecutar_comando("cd $Porticos$NP; perl ../src/latin12utf8.pl");
}

sub generar_imagenes_gif {
    $dd = "mc";
    titulo("2. Se crea $Porticos$NP/drag_drop\n   Se hace tex2gif.pl $dd $dondeestoy");
    ejecutar_comando("cd $Porticos$NP; mkdir -p drag_drop; perl ../src/tex2gif.pl $dd $dondeestoy");
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
        $primer_modelo =~ s/^\s+\vert\{\}\s+$//g; # Limpiar espacios
        
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

# --- SUBRUTINA PARA EJECUTAR Y VALIDAR COMANDOS DE SYSTEM ---
sub ejecutar_comando {
    my ($cmd) = @_;

    my $salida = qx/$cmd/;
    #my $salida = system($cmd 2>&1);
    my $codigo_retorno = $? >> 8; # Obtener el codigo de salida real de Perl
    
    if ($codigo_retorno != 0) {
        system("xterm -title 'SALIDA DE ERROR' -bg red -fg white -e \"echo '$salida'; echo ''; read -p 'Pulsa ENTER para cerrar...'\" &");
        print "\n[AVISO] El comando >>>>$cmd<<<< fallo con código $codigo_retorno\n";
        print "          Se sale completamente del script '$0'\n";
        exit(1);
    }
    
    return $codigo_retorno;
}

sub get_vm_port {
    my ($vm) = @_;
    my $puerto;

    my $cmd = "VBoxManage showvminfo $vm --machinereadable | grep '^Forwarding' |	 grep ',22\"' | cut -d',' -f4";
    print "Buscando el puerto de $vm...";
    $puerto = qx/$cmd/;
    chomp($puerto);
    print "$puerto\n";
    return $puerto;
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
