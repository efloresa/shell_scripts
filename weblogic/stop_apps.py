# $Header: stop_apps.py
# *===========================================================+
# |  Autor - ERIK.FLORES                                      |
# +===========================================================+
# |                                                           |
# | DESCRIPTION                                               |
# |     Detener Aplicaciones weblogic                         |
# | PLATFORM                                                  |
# |     Linux/Solaris/HP-UX                                   |
# |                                                           |
# +===========================================================+

# -*- coding: utf-8 -*-
import sys
import os
import java.lang.Thread as Thread

# Configuración
apps_file = '/datos/atm_jobs/weblogic/apps_to_manage.txt'
user_config = '/datos/atm_jobs/weblogic/myuserconfig.secure'
user_key = '/datos/atm_jobs/weblogic/myuserkey.secure'
admin_url = 't3://srv00pwla05.atm.local:7001'

def conectar():
    connect(userConfigFile=user_config, userKeyFile=user_key, url=admin_url)

def detener(app):
    print('\n--- Procesando parada: ' + app + ' ---')
    try:
        task = stopApplication(app)
        while task.running:
            Thread.sleep(2000)
        print('Resultado: Detenida exitosamente.')
    except Exception, e:
        if "prepared" in str(e).lower() or "not running" in str(e).lower():
            print('INFO: ' + app + ' ya estaba detenida.')
        else:
            print('AVISO: ' + str(e))

# Lógica Principal
try:
    if len(sys.argv) > 1:
        conectar()
        detener(sys.argv[1])
        disconnect()
    else:
        if os.path.exists(apps_file):
            conectar()
            f = open(apps_file, 'r')
            for line in f:
                app_name = line.strip()
                if app_name and not app_name.startswith('#'):
                    detener(app_name)
            f.close()
            disconnect()
except Exception, e:
    print('Error general: ' + str(e))
exit()


