
	for i in f*.ps
	do
		#ps2epsi $i
		#EPSI=`echo $i | sed 's/ps/epsi/'`
		#BB1=`grep "%%BoundingBox: (atend)" $i`
		#BB2=`grep BoundingBox $i | grep -v atend`
		#echo "s/%%BoundingBox:.*/"$BB2"/" > sed.aux
		#cat $i | sed -f sed.aux > xxx
		#mv xxx $i
		awk '{
			if ($1=="%%BoundingBox:" && $2!="(atend)")
				print $1, $3, $2, $5, $4
			else    print $0
		     }' $i |
		sed 's/\\261/-/' > xxx
		mv xxx  $i
		
 	done

	#rm sed.aux

	# Iguala los límites de varios dibujos 
exit

        sh igualXps.sh f3.ps f2.ps
        sh igualYps.sh f3.ps f2.ps
