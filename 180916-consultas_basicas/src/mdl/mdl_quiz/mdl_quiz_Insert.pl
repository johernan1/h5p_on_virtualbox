#!/usr/bin/perl
#

print "Incluyendo fichero: mdl_quiz_Insert\n";

sub mdl_quiz_Insert{
    my $Sub="mdl_quiz_Insert";
    my $name=shift;
    my $intro=shift;
    my $course=shift;
    my $grade=10;
    my $review22=69904;
    iniSub($Sub);
    
    my $consulta="delete from mdl_quiz where name='".$name."' and intro='".$intro."'and course='".$course."'";  
    printT "$consulta\n";  
    
    $dbh->do($consulta) || die "$consulta";
    ###########################################################################
    $consulta="insert into mdl_quiz (name,intro,course,          grade,reviewattempt,reviewcorrectness,reviewmarks,          preferredbehaviour,attemptonlast) VALUES ('$name','$intro',$course,$grade,$review22,$review22,$review22,'deferredfeedback',1)";   
    
    
    $dbh->do($consulta) || die "$consulta\n"; 
    
    #$id=last_insert_Id();  
    $id=mdl_question_categories_Id($shortname,$name);
    finSub($Sub);
    return($id);
}
