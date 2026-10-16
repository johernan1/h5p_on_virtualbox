#!/usr/bin/perl

use Encode qw(decode encode);
use Cwd qw(cwd);
my $dir = cwd;

my ($dd, $dondeestoy)=@ARGV;
#print "dd=$dd, $dondeestoy\n"; exit; 
$PATH="$dir/../src";


print "$PATH\n";
$dir = "tex";

opendir(DIR, "$dir")
	    or die "Could not open dir '$dir' $!";
@FILES = readdir(DIR);

#------------------------------------------------------------------------------
# Figuras
foreach $file (@FILES) {
    # Ignorar los directorios . y ..
    next if ($file eq '.' || $file eq '..');

    # Ignorar subdirectorios
    next if (-d "$dir/$file");

    # Ignorar archivos que terminen en .ps (sensible a mayúsculas/minúsculas)
    next if ($file =~ /\.ps$/i);

    my $ruta_completa = "$dir/$file";

    # Intentar abrir y leer el archivo original en bytes/latin1
    if (open(my $fh_in, '<:raw', $ruta_completa)) {
        local $/; # Modo 'slurp' para leer todo el contenido del fichero
        my $contenido_latin1 = <$fh_in>;
        close($fh_in);

        # Decodificar desde latin1 a la cadena interna de Perl y reencodificar a UTF-8
        my $contenido_utf8 = encode('utf-8', decode('latin1', $contenido_latin1));

        # Sobrescribir el archivo con la nueva codificación UTF-8
        if (open(my $fh_out, '>:raw', $ruta_completa)) {
            print $fh_out $contenido_utf8;
            close($fh_out);
            print "Convertido a UTF-8: $file\n";
        } else {
            warn "No se pudo escribir en '$ruta_completa': $!";
        }
    } else {
        warn "No se pudo leer '$ruta_completa': $!";
    }
}
