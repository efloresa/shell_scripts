
#!/bin/bash

# Configuración
UMBRAL_ALERTA_MB=3072          # Para mostrar advertencia visual
UMBRAL_KILL_MB=4096            # Para matar automáticamente el proceso
LOG_FILE="/datos/atm_jobs/weblogic/weblogic_monitor_cron.log"

echo "Fecha: $(date)"
echo "Servidor WebLogic           PID     Mem(MB)   CPU(%)   Uptime        ACCIÓN"
echo "--------------------------- ------- -------- -------- ------------- --------"

ps -eo pid,pmem,pcpu,etime,command --sort=-%mem | grep '[j]ava' | grep 'Dweblogic.Name=' | while read -r pid mem cpu etime rest; do
    name=$(echo "$rest" | grep -oP '(?<=-Dweblogic.Name=)[^ ]+')
    rss_kb=$(ps -p "$pid" -o rss= | tr -d ' ')
    rss_mb=$((rss_kb / 1024))
    
    accion=""

    if [ "$rss_mb" -gt "$UMBRAL_KILL_MB" ]; then
        accion="💀 KILL ($rss_mb MB)"
        kill -9 "$pid"
        echo "$(date) - Killed server '$name' (PID $pid) for using ${rss_mb}MB" >> "$LOG_FILE"
    elif [ "$rss_mb" -gt "$UMBRAL_ALERTA_MB" ]; then
        accion="⚠️ High Mem"
    fi

    printf "%-27s %-7s %-8s %-8s %-13s %s\n" "$name" "$pid" "$rss_mb" "$cpu" "$etime" "$accion"
done

