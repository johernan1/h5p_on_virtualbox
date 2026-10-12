#!/bin/sh

# Funcion titulo --------------------------------------------------------------
titulo() {
    echo "---------------------------------------------------------------------" >&2
    printf '\033[31m%s corriendo en %s\033[0m\n' "$0" "$(uname -n)" >&2
    [ -n "$1" ] && echo "$1" >&2
    echo >&2
}

titulo "        se lanza maple -b /usr/local/maple/lib -b /usr/local/maple/lib/libTSAM $1"
maple -b /usr/local/maple/lib -b /usr/local/maple/lib/libTSAM $1 || { echo 'Error al hacer maple ... desde $1'; exit 1; }

titulo "        se comprueba que 'tex' es un enlace simbolico a /tmp"
if [ ! -L "tex" ] || [ "$(readlink "tex")" != "/tmp" ]; then
    echo "Error en $0. 'tex' NO es un enlace simbolico a /tmp"
    echo "Error: 'tex' NO es un enlace simbolico a /tmp" >&2
    exit 1
fi


titulo "        se copia 'cp pre-graf.sh tex/$USER-pre-graf.sh'"
cp pre-graf.sh tex/$USER-pre-graf.sh || { echo "Error al hacer 'cp pre-graf.sh tex' desde $0"; exit 1; }

titulo "        se lanza sh $USER-pre-graf.sh"
cd tex
sh $USER-pre-graf.sh || { echo 'Error al hacer "sh pre-graf.sh" desde $1'; exit 1; }
cd ..
#rm tex/pre-graf.sh

