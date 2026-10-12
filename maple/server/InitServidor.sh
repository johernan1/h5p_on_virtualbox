#!/bin/sh

# ==============================================================================
# CONFIGURACIÓN GLOBAL SSH / SCP
# ==============================================================================
SSH_COMMON_OPTS="${2:- -o ConnectTimeout=2 -o ServerAliveInterval=2 -o ServerAliveCountMax=1 -o KexAlgorithms=+diffie-hellman-group1-sha1}"
SSH_LEGACY_OPTS="${3:- -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa}"
SSH_BATCH_OPTS="${4:- -n -o BatchMode=yes}"

# Funcion titulo --------------------------------------------------------------
titulo() {
    echo "---------------------------------------------------------------------" >&2
    printf '\033[31m%s corriendo en %s\033[0m\n' "$0" "$(uname -n)" >&2
    [ -n "$1" ] && echo "$1" >&2
    echo >&2
}

# -----------------------------------------------------------------------------
show_setup_instructions() {
    local modo="${1:-all}"

    # 1. Definición modular de cada sección en variables
    local texto_puertos=" En la máquina virtual hay que 'reenviar puertos' (red/NAT/avanzado):
 Nombre|Protocolo|IP anfitrión|PuertoAnfitrión|IP invitado|PuertoInvitado
   ssh |     TCP |  127.0.0.1 |          2222 | 10.0.2.15 |           22 
                                   ojo, siempre 10.0.2.15"

    local texto_exports=" En el servidor se añade en /etc/exports:
 /home/johernan/ETSAM/h5p/maple *(rw,insecure,sync,no_subtree_check)"

    local texto_ssh=" ssh sin passwd:
   ssh-keygen -t rsa (intro)(intro)...
   copiar contenido de .ssh/id_rsa.pub
   en .ssh/authorized_keys de la máquina virtual
   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/authorized_keys"

    local texto_sudo=" sudo:
    añadir a sudoers
    user ALL=(ALL) NOPASSWD: ALL
    (sudoers se edita con 'sudo visudo')"
    # Encabezado y separador reutilizables
    local separador="---------------------------------------------------------------------"

    if command -v titulo >/dev/null 2>&1; then
        titulo "Instrucciones de configuración ($modo)"
    fi

    echo "$separador" >&2
    echo "--- INSTRUCCIONES ---------------------------------------------------" >&2
    echo "$separador" >&2

    # 2. Selección del bloque a mostrar según el parámetro
    case "$modo" in
        puertos)
            echo "$texto_puertos" >&2
            ;;
        exports|nfs)
            echo "$texto_exports" >&2
            ;;
        ssh)
            echo "$texto_ssh" >&2
            ;;
        sudo)
            echo "$texto_sudo" >&2
            ;;
        all|*)
            # Muestra todos los bloques concatenados sin duplicar el texto fuente
            echo "$texto_puertos" >&2
            echo "" >&2
            echo "$texto_exports" >&2
            echo "" >&2
            echo "$texto_ssh" >&2
            echo "" >&2
            echo "$texto_sudo" >&2
            ;;
    esac

    echo "$separador" >&2
}

# Funcion ensure_vm_running ---------------------------------------------------
ensure_vm_running() {
    local vm="$1"
    titulo "Chequeos preliminares de la VM: $NOMBRE_VM"
    titulo "    Ensure_vm_running '$vm'"
    if ! VBoxManage list vms | grep -q "\"$vm\""; then
        echo "Error: La máquina '$vm' no está instalada." >&2
        return 1  # Aborta la ejecución completa del script
    fi
    echo "    [II] '$vm' instalada"
    # Comprobar si ya está en ejecución
    if ! VBoxManage list runningvms | grep -q "\"$vm\""; then
	# Intentar arrancar la máquina virtual
	titulo "    '$vm' apagada. Se inicia la maquina virtual en segundo plano"
	VBoxHeadless --startvm "$vm" --vrdp=off 2>&1 &
	
	i=0
	imax=3
	while ! VBoxManage list runningvms | grep -q "\"$vm\""; do
            i=$((i + 1))
	    echo "    [WW] .............................$i/$imax"
            if [ "$i" -ge "$imax" ]; then
		echo "Error: La máquina '$vm' falló al arrancar. $i/$imax" >&2
		return 1 # Aborta la ejecución completa del script
            fi
            sleep 1
	done
    fi

    echo "    [II] '$vm' corriendo"
}

# ------------------------------------------------------------------------------
get_vm_net_type() {
    local vm="$1"
    
    titulo "    Get_vm_net_type '$vm'." >&2 # redirigido para que no lo 'return' la funcion  
    TIPO_RED=$(VBoxManage showvminfo "$vm" --machinereadable | grep '^nic1=' | cut -d'"' -f2)
    echo "$TIPO_RED"
}

function_nat() {
    local vm="$1"
    local puerto=""

    # 1. Extraer el puerto del host asociado al puerto 22 (SSH) de la VM
    puerto=$(VBoxManage showvminfo "$vm" --machinereadable | \
        grep '^Forwarding' | \
        grep ',22"' | \
        cut -d',' -f4)

    # 2. Verificar que se haya encontrado un puerto válido
    if [ -z "$puerto" ]; then
        
        echo "Error: No se encontró ninguna regla de port forwarding para SSH (puerto 22) en la VM '$vm'." >&2
        show_setup_instructions puertos >&2
        return 1
    fi

    # 3. Devolver únicamente el puerto por stdout
    echo "    [II] La VM '$vm' tiene el puerto NAT: $puerto" >&2
    echo "$puerto"
    return 0
}

# ------------------------------------------------------------------------------
get_ssh_options() {
    local red="$1"
    local vm="$2"

    echo "    [II] Comprobando tipo de red de '$vm'...${red}" >&2
    case "$red" in
	nat)
            PORT=$(function_nat "$vm") || return 1
            echo $PORT
            ;;
	*)
            echo "Error: Tipo de red desconocido o no soportado ('$red')." >&2
            echo "Error: Soportados unicamente: nat." >&2
            echo "Error: Debe configurarse adecuadamente la red de la VM '$vm'." >&2
            return 1  
            ;;
    esac
}

# ------------------------------------------------------------------------------
test_ssh_vm_connection() {
    local port="$1"
    local cmd="${2:-uname -a}"
    local msg_ok="${3:-Acceso mediante SSH a la máquina virtual.}"
    local msg_err="${4:-No se pudo conectar a la VM tras}"

    local max_reintentos="${5:-20}"
    local contador=0
    local log_error="/tmp/${USER}virtualboxcorriendo"
    local salida=""
    local status=1

    ssh1_cmd="ssh -n -o BatchMode=yes -p '$port' -o ConnectTimeout=2 -o ServerAliveInterval=2 -o ServerAliveCountMax=1 -o KexAlgorithms=+diffie-hellman-group1-sha1 localhost '$cmd'"
    ssh2_cmd="ssh -n -o BatchMode=yes -p '$port' -o ConnectTimeout=2 -o ServerAliveInterval=2 -o ServerAliveCountMax=1 -o KexAlgorithms=+diffie-hellman-group1-sha1 -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa localhost '$cmd'"
    
    ssh1_cmd="ssh $SSH_BATCH_OPTS $SSH_COMMON_OPTS -p '$port' localhost '$cmd'"
    ssh2_cmd="ssh $SSH_BATCH_OPTS $SSH_COMMON_OPTS $SSH_LEGACY_OPTS -p '$port' localhost '$cmd'"

    titulo "    Test_ssh_vm_connection -p '$port' cmd='$cmd'." >&2
    echo "0" > "$log_error"

    while [ -s "$log_error" ] && [ "$contador" -lt "$max_reintentos" ]; do
        contador=$((contador + 1))
        
        printf "    [II] Intentando SSH a la VM (intento %d/%d) " "$contador" "$max_reintentos" >&2
        printf "    [II] Intentando SSH a la VM (intento %d/%d)\n" "$contador" "$max_reintentos" >> "$log_error"

        # Intento 1: Comando primario
        printf "Ejecutando:\n %s\n" "$ssh1_cmd" >> "$log_error"
        salida=$(eval "$ssh1_cmd" 2>> "$log_error")
        status=$?

        # Fallback si el intento 1 devuelve error (status != 0)
        if [ "$status" -ne 0 ]; then
            printf "Ejecutando fallback:\n %s\n" "$ssh2_cmd" >> "$log_error"
            salida=$(eval "$ssh2_cmd" 2>> "$log_error")
            status=$?
        fi

        # Evaluar si SSHD respondió correctamente
        if [ "$status" -eq 0 ]; then
            : > "$log_error"
            printf " [OK]\n    [II] %s\n" "$msg_ok" >&2
            [ -n "$salida" ] && printf "         Salida:\n%s\n" "$salida" >&2
            return 0
        else
            printf " [Esperando a que sshd responda...]\n" >&2
            sleep 2
        fi
    done

    printf "Error: %s %d intentos.\n" "$msg_err" "$max_reintentos" >&2
    xterm -hold -e cat "$log_error" &
    return 1
}

# ------------------------------------------------------------------------------
check_remote_sudo() {
    local port="$1"
    local intentos="2"
    test_ssh_vm_connection "$port" "sudo  -k; sudo -v </dev/null" \
        "El usuario tiene permisos sudo NOPASSWD en la VM." \
        "El usuario no tiene sudo o requiere contraseña." "$intentos"  || { 
            show_setup_instructions sudo
            return 1
        } 
    return 0
}

# ------------------------------------------------------------------------------
check_ssh_key_auth() {
    local port="$1"
    local intentos="10"
    test_ssh_vm_connection "$port" "true" \
        "Conexión SSH por clave pública correcta (sin contraseña)." \
        "No se pudo autenticar mediante clave pública SSH." "$intentos"  || { 
            show_setup_instructions ssh >&2
            return 1
        }
    return 0
}

# ------------------------------------------------------------------------------
create_mount_vigas_script() {
    local script_name="mountVigas1vano.sh"

    titulo "    Creando/Actualizando $script_name..." >&2

    EXPORT=`cat /etc/exports`
    DIRNAME=`dirname $PWD`
    
    cat > "$script_name" <<EOF
    #!/bin/sh

    echo "         ............................................................" >&2
    echo "         \$0 corriendo en \$(uname -n)" >&2
    echo "         Fichero creado por $0 en $(uname -n)" >&2
    echo "         >>>> NO EDITAR, SE SOBREESCRIBIRA <<<<" >&2
    echo "         los cambios deben hacerse en $0->create_mount_vigas_script" >&2
    echo "         >>>> NO EDITAR, SE SOBREESCRIBIRA <<<<" >&2
    echo "         the name of the script is \$0" >&2

    # Obtener la dirección IP de la interfaz usando ifconfig
    addr=\`/sbin/ifconfig | grep addr:10 | sed s/Bcast.*// | sed s/.*addr://\`

    echo "         addr \$addr" >&2

    # Garantizar que el directorio exista 
    mkdir -p vigas1vano

    if [ -n "\$1" ]; then
        if mountpoint -q vigas1vano; then
            echo "         vigas1vano is mounted" >&2
        else
            echo "    vigas1vano isn't mounted ..." >&2
            sudo mount \$1:${PWD%/*} vigas1vano
            if mountpoint -q vigas1vano; then
                echo "         vigas1vano is mounted" >&2
            else
                echo "Error: No se ha podido montar vigas1vano" >&2
                echo "            Probar sudo apt install -y nfs-common" >&2
		echo "            Comprobar permisos en $(uname -n) "  >&2
                echo "            El fichero /etc/exports" >&2
                echo "            debe incluir $DIRNAME *(rw,insecure,sync,no_subtree_check)" >&2
		echo "            Su contenido actual es: cat /etc/exports"  >&2
                echo "            ******************************"  >&2
                echo "$EXPORT"  >&2
                echo "            ******************************"  >&2
                echo "            Una vez modificado /etc/exports debe hacerse"  >&2
                echo "            sudo systemctl restart nfs-kernel-server"  >&2
                exit 1;
            fi    
        fi
    else
        echo "         falta dirección de servidor" >&2 
    fi

    echo "         Fin de \$0" >&2
    echo "         ............................................................" >&2
EOF
}

# ------------------------------------------------------------------------------
copy_mount_vigas_script() {
    local script_name="mountVigas1vano.sh"
    local puerto="$1"
    local log_error="/tmp/${USER}virtualboxcorriendo"
    local salida=""
    local status=1

    # Verificar que el archivo exista antes de intentar copiarlo
    if [ ! -f "$script_name" ]; then
        echo "Error: El archivo '$script_name' no existe en el directorio actual." >&2
        return 1
    fi

    titulo "    Copiando $script_name a la máquina virtual (puerto $puerto)..." >&2

    scp1_cmd="scp $SSH_COMMON_OPTS -P '$puerto' $script_name localhost:"
    scp2_cmd="scp $SSH_COMMON_OPTS $SSH_LEGACY_OPTS -P '$puerto' $script_name localhost:"
    
    #eval "$scp1_cmd" >/dev/null 2>&1 || \
	#eval "scp2_cmdscp" >/dev/null 2>&1

    # Intento 1: Comando primario
    printf "Ejecutando:\n %s\n" "$scp1_cmd" >> "$log_error"
    salida=$(eval "$scp1_cmd" 2>> "$log_error")
    status=$?

    # Fallback si el intento 1 devuelve error (status != 0)
    if [ "$status" -ne 0 ]; then
        printf "Ejecutando fallback:\n %s\n" "$scp2_cmd" >> "$log_error"
        salida=$(eval "$scp2_cmd" 2>> "$log_error")
        status=$?
    fi

    if [ $? -eq 0 ]; then
        echo "    [OK] Archivo $script_name copiado con exito a la VM." >&2
        return 0
    else
        echo "Error: No se pudo copiar $script_name a la máquina virtual." >&2
	    xterm -hold -e cat "$log_error" &
        return 1
    fi
}

# ------------------------------------------------------------------------------
execute_mount_vigas_script() {
    local puerto="$1"
    local script_remote="mountVigas1vano.sh"
    local server_ip="10.0.2.2"
    
    # Construir la orden a ejecutar dentro de la VM
    local cmd_remoto="sh $script_remote $server_ip"
    
    # Mensajes personalizados de éxito y error
    local msg_ok="El script '$script_remote' se ejecutó correctamente en la VM."
    local msg_err="Falló la ejecución de '$script_remote' en la máquina virtual."

    titulo "    Ejecutando '$script_remote $server_ip' en la máquina virtual..." >&2
    echo "    [WW] sudo visudo y añadir '$USER ALL=(ALL) NOPASSWD: ALL'" >&2

    # Reutilizar la función centralizada de SSH pasando el comando
    test_ssh_vm_connection "$puerto" "$cmd_remoto" "$msg_ok" "$msg_err"
    return $?
}

# Main
#--------------------------------------------------------------------------
NOMBRE_VM="${1:-debian vigas1vanoMaple}"
#NOMBRE_VM="${1:-debian 11 moodle3}"
#--------------------------------------------------------------------------
show_setup_instructions all
ensure_vm_running "$NOMBRE_VM" || exit 1
RED=$(get_vm_net_type "$NOMBRE_VM") || exit 1
PORT=$(get_ssh_options "$RED" "$NOMBRE_VM") || exit 1
check_ssh_key_auth "$PORT" || exit 1
check_remote_sudo "$PORT" || exit 1
test_ssh_vm_connection "$PORT"|| exit 1 

create_mount_vigas_script
copy_mount_vigas_script "$PORT" || exit 1 
execute_mount_vigas_script "$PORT"|| exit 1 
titulo "Fin de $0"
echo "---------------------------------------------------------------------" >&2

exit 0
