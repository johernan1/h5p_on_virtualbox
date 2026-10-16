use strict;
use warnings;

# Subrutina que construye y empaqueta el nuevo panel en la ventana Tk principal
sub crear_panel_opciones_extra {
    my ($parent_widget) = @_;

    # --- NUEVO GRUPO: OPCIONES DE DIBUJO Y CÁLCULO ---
    my $f_opciones_extra = $parent_widget->Labelframe(
        -text => " Opciones de Dibujo, Escalas y Perfiles ",
        -padx => 10,
        -pady => 8
    )->pack(-fill => 'x', -padx => 10, -pady => 5);

    # Fila 1: Opciones Booleanas / Selección de Modo (Radiobuttons y Checkbuttons)
    my $f_opt_f1 = $f_opciones_extra->Frame->pack(-fill => 'x', -pady => 2);

    $f_opt_f1->Checkbutton(
        -text     => "Imprimir Cotas",
        -variable => \$main::opcionC
	)->pack(-side => 'left');

    $f_opt_f1->Checkbutton(
        -text     => "Texto Ampliado",
        -variable => \$main::textoAmpliado
	)->pack(-side => 'left', -padx => 10);

    $f_opt_f1->Checkbutton(
        -text     => "Incluir/Procesar",
        -variable => \$main::opcion_tex
	)->pack(-side => 'left', -padx => 10);


    #my $f_opt_f2 = $f_opciones_extra->Frame->pack(-fill => 'x', -pady => 2);
    #$f_opt_f2->Label(-text => "Fichero TeX:")->pack(-side => 'left');
    #$f_opt_f2->Radiobutton(-text => "Procesar (1)", -value => 1, -variable => \$main::opcion_tex)->pack(-side => 'left');
    #$f_opt_f2->Radiobutton(-text => "Incluir (2)",  -value => 2, -variable => \$main::opcion_tex)->pack(-side => 'left');

    # Fila 2: Escalas (Entradas alineadas)
    my $f_escalas = $f_opciones_extra->Frame->pack(-fill => 'x', -pady => 4);
    $f_escalas->Label(-text => "Escalas ->")->pack(-side => 'left');

    $f_escalas->Label(-text => "Lv:")->pack(-side => 'left');
    $f_escalas->Entry(-textvariable => \$main::escal, -width => 5)->pack(-side => 'left', -padx => [0, 5]);

    $f_escalas->Label(-text => "Puntual:")->pack(-side => 'left');
    $f_escalas->Entry(-textvariable => \$main::escalP, -width => 5)->pack(-side => 'left', -padx => [0, 5]);

    $f_escalas->Label(-text => "Distrib.:")->pack(-side => 'left');
    $f_escalas->Entry(-textvariable => \$main::escalq, -width => 5)->pack(-side => 'left', -padx => [0, 5]);

    $f_escalas->Label(-text => "Momento:")->pack(-side => 'left');
    $f_escalas->Entry(-textvariable => \$main::escalM, -width => 5)->pack(-side => 'left');

    # Fila 3: Menús desplegables (OptionMenu) para Perfiles y Comprobaciones
    my $f_combos = $f_opciones_extra->Frame->pack(-fill => 'x', -pady => 4);

    # Desplegable de Perfiles
    $f_combos->Label(-text => "Perfil:", -anchor => 'w')->pack(-side => 'left');
    $f_combos->Optionmenu(
        -variable => \$main::perfiles,
	-width    => 20,
        -options  => [
            ['1. IPE'                       => 1],
            ['2. IPE+1f (pendiente)'        => 2],
            ['3. HEA (pendiente)'           => 3],
            ['4. bxh madera'                => 4],
            ['5. bxh.bxh madera'            => 5],
            ['6. dobleT S275 no simetrica'  => 6],
            ['7. IPN'                       => 7],
            ['8. T invertida S275'          => 8],
            ['9. HEB S275'                  => 9],
        ]
    )->pack(-side => 'left', -padx => [2, 10]);

    # Desplegable de Comprobaciones
    $f_combos->Label(-text => "Comprobacion:", -anchor => 'w')->pack(-side => 'left');
    $f_combos->Optionmenu(
        -variable => \$main::comprobaciones,
	-width    => 30,
        -options  => [
            ['x,0  Solo dimensionamiento'               => 0],
            ['x,1  E/R'                                 => 1],
            ['x,2  sigma'                               => 2],
            ['x,3  sigma + tau'                         => 3],
            ['x,4  sigma + ME/MR'                       => 4],
            ['x,5  sigma + tau + ME/MR'                 => 5],
            ['x,6  sigma + tau + ME/MR + VE/VR'         => 6],
            ['x,7  sigma + tau + VM'                    => 7],
            ['x,8  sigma + tau + VM + ME/MR'            => 8],
            ['x,9  sigma + tau + VM + ME/MR + VE/VR'    => 9],
            ['x,10* tau extremo izquierdo'             => 10],
            ['x,20* tau extremo derecho'               => 20],
            ['x,30* tau extremo M=0 (o Vmax)'           => 30],
        ]
    )->pack(-side => 'left', -padx => [2, 0]);
}

1; # Retorno verdadero obligatorio para archivos requeridos en Perl
