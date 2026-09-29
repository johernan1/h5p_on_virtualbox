#!/bin/sh

echo "---------------------------------------------------------------------"
echo "---INSTRUCCIONES-----------------------------------------------------"
echo "---------------------------------------------------------------------"
echo $0
echo " En la máquina virtual hay que 'reenviar puertos' (red/NAT/avanzado):"
echo " Nombre|Protocolo|IP anfitrión|PuertoAnfitrión|IP invtado|PuertoInvitado" 
echo "   ssh |     TCP |  127.0.0.1 |          2222 | 10.0.2.15| 22 "
echo ""
echo " En el servidor se añade en /etc/export"
echo " /home/johernan/ETSAM/h5p/maple *(rw,insecure,sync,no_subtree_check)"
echo ""
echo "ssh sin passwd:"
echo "   ssh-keygen -t rsa (intro)(intro)..."
echo "   copiar contenido de .ssh/id_rsa.pub"
echo "   en .ssh/authorized_keys de la máquina virtual"
echo "---------------------------------------------------------------------"
echo "---------------------------------------------------------------------"
echo "---------------------------------------------------------------------"
# Se inicia la maquina virtual en 'segundo plano'
#VBoxHeadless --startvm 'debian vigas1vanoMaple' --vrdp=off 2>/tmp/1.$$ &
#if [ "$?" -ne "0" ]; then
#    $aux=$?
#    echo "Sorry, we had a problem there!"
#    grep 'already' /tmp/1.$$
#fi

echo "---------------------------------------------------------------------"
echo $0
echo "Se inicia la maquina virtual en segundo plano"
echo "---------------------------------------------------------------------"
VBoxHeadless --startvm 'debian vigas1vanoMaple' --vrdp=off 2>/tmp/1.$$ &

echo "xxxx" > /tmp/virtualboxcorriendo
while test -s /tmp/virtualboxcorriendo
do  echo $0
    echo 'Intentando ssh a la maquina virtual (puede tardar la primera vez)'
    echo '-----------------'
    #ssh localhost -p 2222 -oKexAlgorithms=+diffie-hellman-group1-sha1 'uname -a' 2>/tmp/virtualboxcorriendo;
    ssh localhost \
	-p 2222 \
	-oKexAlgorithms=+diffie-hellman-group1-sha1 \
	'uname -a' \
	2>/tmp/virtualboxcorriendo \
	|| ssh localhost \
	       -p 2222 \
	       -oKexAlgorithms=+diffie-hellman-group1-sha1 \
	       -oHostKeyAlgorithms=+ssh-rsa \
	       -oPubkeyAcceptedAlgorithms=+ssh-rsa \
	       'uname -a' \
	       2>/tmp/virtualboxcorriendo
    cat /tmp/virtualboxcorriendo 
done  

#echo "$command\n";
#$command;
echo "---------------------------------------------------------------------"
echo $0
echo "La maquina virtual esta iniciada"
echo "---------------------------------------------------------------------"
echo $0
echo "Se actualiza mountVigas1vano.sh"
#sed 's@sudo mount .*@sudo mount \$1:'"$PWD"' vigas1vano@' mountVigas1vano.sh > mountVigas1vanoAuto.sh
echo "
echo \"    ----------------------------------------------------------------\"
echo \"    \$0\"
echo \"    the name of the script is \$0\"

#addr=\`sudo ifconfig | grep addr:10 | sed s/Bcast.*// | sed s/.*addr://\`
addr=\`/sbin/ifconfig | grep addr:10 | sed s/Bcast.*// | sed s/.*addr://\`

echo \"    addr \$addr\"

if [ -n \"\$1\" ]
then
    if mountpoint -q vigas1vano; then
      echo \"vigas1vano is mounted\"
    else
      echo \"vigas1vano isn't mounted\"
      sudo mount \$1:$PWD vigas1vano
    fi
else
  echo \"    falta dirección de servidor\"
fi
echo \"    Fin de \$0\"
" > mountVigas1vano.sh


echo "---------------------------------------------------------------------"
echo $0
echo "Se copia mountVigas1vano.sh a la máquina virtual"
echo "---------------------------------------------------------------------"
#scp -P 2222 -oKexAlgorithms=+diffie-hellman-group1-sha1  mountVigas1vano.sh localhost:
scp -P 2222 \
    -oKexAlgorithms=+diffie-hellman-group1-sha1 \
    mountVigas1vano.sh localhost: \
    || {
    echo "Reintentando con algoritmos legacy..."
    scp -P 2222 \
        -oKexAlgorithms=+diffie-hellman-group1-sha1 \
        -oHostKeyAlgorithms=+ssh-rsa \
        -oPubkeyAcceptedAlgorithms=+ssh-rsa \
        mountVigas1vano.sh localhost:
}
echo "---------------------------------------------------------------------"
echo $0
echo "Se hace \"mountVigas1vano.sh 10.0.2.2\" en la máquina virtual. El resultado es que"
echo "se monta " $PWD " en la maquina virtual"
#ssh localhost -oKexAlgorithms=+diffie-hellman-group1-sha1 -p 2222 'sh  mountVigas1vano.sh 10.0.2.2'
ssh localhost \
    -p 2222 \
    -oKexAlgorithms=+diffie-hellman-group1-sha1 \
    'sh mountVigas1vano.sh 10.0.2.2' \
    || ssh localhost \
	   -p 2222 \
	   -oKexAlgorithms=+diffie-hellman-group1-sha1 \
	   -oHostKeyAlgorithms=+ssh-rsa \
	   -oPubkeyAcceptedAlgorithms=+ssh-rsa \
	   'sh mountVigas1vano.sh 10.0.2.2'
#system ("ssh localhost -p 2222 'sh  mountVigas1vano.sh 10.0.2.2'");
echo "---------------------------------------------------------------------"
echo 'Fin de ' $0
echo "---------------------------------------------------------------------"
