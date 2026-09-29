
echo "    ----------------------------------------------------------------"
echo "    $0"
echo "    the name of the script is $0"

#addr=`sudo ifconfig | grep addr:10 | sed s/Bcast.*// | sed s/.*addr://`
addr=`/sbin/ifconfig | grep addr:10 | sed s/Bcast.*// | sed s/.*addr://`

echo "    addr $addr"

if [ -n "$1" ]
then
    if mountpoint -q vigas1vano; then
      echo "vigas1vano is mounted"
    else
      echo "vigas1vano isn't mounted"
      sudo mount $1:/home/johernan/ETSAM/h5p/maple vigas1vano
    fi
else
  echo "    falta dirección de servidor"
fi
echo "    Fin de $0"

