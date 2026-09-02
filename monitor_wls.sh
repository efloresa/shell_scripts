#!/bin/bash
# -------- CONFIGURACION --------
ADMIN_URL="t3://srv00pwla05.atm.local:7001"
USER="weblogic"
PASSWORD="Jempnmf$al23#1"
MANAGED_SERVERS="AxisAutoTPServer4 AxisPortalServer4 AxisServer4 IntegraDTTServer4 SVTServer4 WebServicesServer4 WsBancosServer4"
CORREO="erik.flores@atm.gob.ec"
TG_TOKEN="7416203206"
TG_CHAT_ID="7343413063"
WLST="/u01/app/Middleware/12.2.1.3.0/oracle_common/common/bin/wlst.sh"
# --------------------------------
# Modo mantenimiento
if [ -f /tmp/wls_maintenance.flag ]; then
    exit 0
fi

TMPFILE=$(mktemp)

cat > "$TMPFILE" <<EOF
connect('$USER', '$PASSWORD', '$ADMIN_URL')

servers = "$MANAGED_SERVERS".split()
print $servers

down = []

for s in servers:
    try:
        st = state(s, 'Server')
        if st != 'RUNNING':
            down.append((s, st))
    except:
        down.append((s, 'UNKNOWN'))

disconnect()

if len(down) > 0:
    print("DOWN:", down)
else:
    print("OK")
EOF

RESULT=$($WLST "$TMPFILE" 2>&1)
rm -f "$TMPFILE"

echo "$RESULT" | grep -q "OK"
if [ $? -eq 0 ]; then
    exit 0
fi

MENSAJE="$(date '+%Y-%m-%d %H:%M:%S') - ALERTA WebLogic: $RESULT"

# Envío correo
echo "$MENSAJE" | mail -s "ALERTA WebLogic" "$CORREO"

# Envío Telegram
curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN/sendMessage" \
  -d chat_id="$TG_CHAT_ID" \
  -d text="$MENSAJE" >/dev/null

exit 2
