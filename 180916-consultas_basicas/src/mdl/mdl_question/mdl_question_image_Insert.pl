#!/usr/bin/perl
#
use File::Path;

print "Incluyendo fichero: mdl_question_image_Insert\n";

sub mdl_question_image_Insert{
    my $id=shift;
    my $image=shift;
    my $component=shift;
    my $filearea=shift;
    my $Sub="mdl_question_image_Insert";
    iniSub($Sub);


    my $dirimage=$exceldir;
    #$dirimage=~s:[/\\][^/\\]*$::g;
    if (not -e "$dirimage/$image") {
	warn "No existe el fichero $dirimage/$image\n";
	pausa();
    }


    $contextid=mdl_question_categories_Contextid($shortname);
    #$component='question';
    #$filearea="questiontext";
    $itemid=$id;
    mdl_files_Insert("$dirimage","$image", $contextid,
		     $component,$filearea, $itemid);

    finSub($Sub);
    return $id
}

sub moodle_19{  
    my $id=shift;
    my $image=shift;
    my $category=shift;
    my $Sub="mdl_question_image_Insert";
    iniSub($Sub); 
    $category=~s/:/_/g;
    my $dir="$moodledata/$courseid/$shortname/$ejercicio/$category";

    eval { mkpath($dir) };
    if ($@) {
	die "Couldn't create $dir: $@";
    }  
    my $dirimage=$exceldir;
    #$dirimage=~s:[/\\][^/\\]*$::g;
    if (not -e "$dirimage/$image") {
	warn "No existe el fichero $dirimage/$image\n";
	pausa();
    }
    copy("$dirimage/$image","$dir");

     
 
    my $consulta="update mdl_question set image='$shortname/$ejercicio/$category/$image' where id=$id";
    $dbh->do($consulta)||die "$consulta";


    finSub($Sub);
    return $id
}
