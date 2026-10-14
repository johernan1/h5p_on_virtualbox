#!/usr/bin/perl
#
use File::Path;

print "Incluyendo fichero: mdl_h5p_image_Insert\n";

sub mdl_h5p_image_Insert{
    my $id=shift;
    my $image=shift;
    my $component=shift;
    my $filearea=shift;
    my $Sub="mdl_h5p_image_Insert";
    iniSub($Sub);


    my $dirimage=$exceldir;
    #$dirimage=~s:[/\\][^/\\]*$::g;
    if (not -e "$dirimage/$image") {
	warn "No existe el fichero $dirimage/$image\n";
	pausa();
    }
    $itemid=mdl_h5p_id($id);
    printT "$id->$itemid, $image, $component, $filearea\n";
    $contextid=mdl_h5p_Contextid($id);
    #$component='h5p';
    #$filearea="h5ptext";
    printT "itemid.....$Sub........$itemid\n";
    printT "contextid..$Sub........$contextid->itemid=$itemid\n";
    printT "component..$Sub........$component\n";
    printT "filearea...$Sub........$filearea\n";
    #$itemid=$contextid; #Esto es incorrecto. Chapuza para poder continuar
#while(siono("contextid=$contextid iditem=$iditem pulsar y para continuar",'si','no') eq 'si') {}; 
    mdl_files_Insert("$dirimage","$image", $contextid-1,
		     $component,'', $itemid, $filearea);

    finSub($Sub);
    return $id
}
