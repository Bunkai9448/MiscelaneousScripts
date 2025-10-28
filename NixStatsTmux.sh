#!/bin/bash

# En muchas peliculas, antiguas y modernas, para dar un efecto visual de actividad informatica intensa, se muestran 
# en las pantallas de ordenadores los recursos y procesos del sistema. Estos suelen ser generados por herramientas 
# de monitoreo en Linux que producen graficos o interfaces dinamicas en la terminal. A continuacion, se describe un 
# script Bash que busca dar informacion del estado en vivo del sistema y a la vez conseguir ese efecto visual.

# Colores para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # Sin color

# Funcion para verificar e instalar paquetes
install_if_missing() {
    PACKAGE=$1
    INSTALL_CMD=$2
    if ! command -v $PACKAGE &> /dev/null; then
        echo -e "${RED}Instalando $PACKAGE...${NC}"
        eval $INSTALL_CMD
    else
        echo -e "${GREEN}$PACKAGE ya esta instalado.${NC}"
    fi
}

# Instalar herramientas
install_if_missing htop "sudo apt install -y htop" # Monitor de procesos interactivo centrado en CPU
install_if_missing glances "sudo apt install -y glances" # Dashboard de monitoreo completo del sistema 
install_if_missing nmon "sudo apt install -y nmon" # Monitor interactivo del sistema en consola
install_if_missing dstat "sudo apt install -y dstat"
install_if_missing neofetch "sudo apt install -y neofetch" # Informacion del sistema mostrada de forma estetica
install_if_missing screenfetch "sudo apt install -y screenfetch"
install_if_missing cmatrix "sudo apt install -y cmatrix" # Pantalla estilo "Matrix" no monitorea nada
install_if_missing iotop "sudo apt install -y iotop"
install_if_missing tmux "sudo apt install -y tmux"
install_if_missing netstat "sudo apt install -y net-tools" # Para netstat
install_if_missing iftop "sudo apt install -y iftop" # Para monitoreo de red
install_if_missing vnstat "sudo apt install -y vnstat" # Estadisticas de red
install_if_missing iostat "sudo apt install -y sysstat" # Para vmstat e iostat

# Crear scripts temporales para comandos dinamicos con watch
cat << 'EOF' > /tmp/cpu_monitor.sh
#!/bin/bash
watch -n 1 "ps aux --sort=-%cpu | head -n 10"
EOF
chmod +x /tmp/cpu_monitor.sh

cat << 'EOF' > /tmp/mem_monitor.sh
#!/bin/bash
watch -n 1 "free -h"
EOF
chmod +x /tmp/mem_monitor.sh

cat << 'EOF' > /tmp/disk_monitor.sh
#!/bin/bash
watch -n 1 "df -h"
EOF
chmod +x /tmp/disk_monitor.sh

cat << 'EOF' > /tmp/net_monitor.sh
#!/bin/bash
watch -n 1 "netstat -tuln"
EOF
chmod +x /tmp/net_monitor.sh

cat << 'EOF' > /tmp/uptime_monitor.sh
#!/bin/bash
watch -n 1 "uptime"
EOF
chmod +x /tmp/uptime_monitor.sh

cat << 'EOF' > /tmp/vmstat_monitor.sh
#!/bin/bash
watch -n 1 "vmstat -s"
EOF
chmod +x /tmp/vmstat_monitor.sh

cat << 'EOF' > /tmp/iostat_monitor.sh
#!/bin/bash
watch -n 1 "iostat -x"
EOF
chmod +x /tmp/iostat_monitor.sh

cat << 'EOF' > /tmp/dstat_monitor.sh
#!/bin/bash
dstat -cdngy
EOF
chmod +x /tmp/dstat_monitor.sh

cat << 'EOF' > /tmp/iftop_monitor.sh
#!/bin/bash
# Ejecuta iftop en la interfaz predeterminada (puede necesitar permisos de root)
sudo iftop -i $(ip route | awk '/default/ {print $5}' | head -n 1)
EOF
chmod +x /tmp/iftop_monitor.sh

cat << 'EOF' > /tmp/vnstat_monitor.sh
#!/bin/bash
watch -n 1 "vnstat -l"
EOF
chmod +x /tmp/vnstat_monitor.sh

# Lanzar tmux con multiples herramientas y comandos en paneles divididos
echo -e "${GREEN}Lanzando tmux con herramientas de monitoreo y comandos del sistema...${NC}"
tmux new-session -d 'htop' \; \
    split-window -h 'cmatrix' \; \
    split-window -v 'glances' \; \
    select-pane -t 0 \; \
    split-window -v '/tmp/cpu_monitor.sh' \; \
    select-pane -t 2 \; \
    split-window -h '/tmp/mem_monitor.sh' \; \
    select-pane -t 0 \; \
    split-window -h '/tmp/disk_monitor.sh' \; \
    select-pane -t 2 \; \
    split-window -v '/tmp/net_monitor.sh' \; \
    select-pane -t 4 \; \
    split-window -v '/tmp/uptime_monitor.sh' \; \
    select-pane -t 6 \; \
    split-window -h '/tmp/vmstat_monitor.sh' \; \
    select-pane -t 8 \; \
    split-window -v '/tmp/iostat_monitor.sh' \; \
    select-pane -t 9 \; \
    split-window -h '/tmp/dstat_monitor.sh' \; \
#    select-pane -t 10 \; \
#    split-window -v 'nmon' \; \
#    select-pane -t 11 \; \
#    split-window -h '/tmp/iftop_monitor.sh' \; \
#    select-pane -t 12 \; \
#    split-window -v '/tmp/vnstat_monitor.sh' \; \
#    select-pane -t 13 \; \
#    split-window -h 'neofetch' \; \ # Informacion del sistema de forma estetica
tmux attach-session

# Limpiar scripts temporales al salir
trap "rm -f /tmp/cpu_monitor.sh /tmp/mem_monitor.sh /tmp/disk_monitor.sh /tmp/net_monitor.sh /tmp/uptime_monitor.sh /tmp/vmstat_monitor.sh /tmp/iostat_monitor.sh /tmp/dstat_monitor.sh /tmp/iftop_monitor.sh /tmp/vnstat_monitor.sh" EXIT
