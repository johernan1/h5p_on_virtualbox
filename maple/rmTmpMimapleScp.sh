#!/bin/sh

# Funcion titulo --------------------------------------------------------------
titulo() {
    echo "---------------------------------------------------------------------" >&2
    printf '\033[31m%s corriendo en %s\033[0m\n' "$0" "$(uname -n)" >&2
    [ -n "$1" ] && echo "$1" >&2
    echo >&2
}

# -----------------------------------------------------------------------------
titulo "    para chequeo hacer sh Mimaple $1"
echo '    se borra /tmp' >&2
rm /tmp/* 2>/dev/null

# -----------------------------------------------------------------------------
titulo "    se hace sh Mimaple $1 > /dev/null"
sh Mimaple.sh $1 || { echo "Error al hacer 'sh Mimaple.sh' desde $0"; exit 1; }

#titulo "    se copia /tmp al /tmp de la maquina anfitriona 10.0.2.2"
#echo '----------------------------------------------------------------------'
#echo $0
#echo 'se copia /tmp al /tmp de la maquina anfitriona'
#echo '----------------------------------------------------------------------'
#scp -r /tmp 10.0.2.2:/tmp

echo '----------------------------------------------------------------------'
echo 'Fin ' $0
echo '----------------------------------------------------------------------'
