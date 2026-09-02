# $Header: start_apps.py
# *===========================================================+
# |  Autor - ERIK.FLORES                                      |
# +===========================================================+
# |                                                           |
# | DESCRIPTION                                               |
# |     Iniciar Aplicaciones weblogic                         |
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

def iniciar(app):
    print('\n--- Procesando inicio: ' + app + ' ---')
    try:
        # Ejecutamos y capturamos el progreso
        task = startApplication(app)
        while task.running:
            Thread.sleep(2000)
        
        if task.completed:
            print('Resultado: OK para ' + app)
        else:
            print('Resultado: Revisar estado de ' + app)
    except Exception, e:
        # Si ya está activa, WebLogic 12c a veces lanza error, lo capturamos aquí
        if "already active" in str(e).lower() or "same running task" in str(e).lower():
            print('INFO: ' + app + ' ya esta activa o tiene una tarea en curso.')
        else:
            print('AVISO: No se pudo completar el inicio de ' + app + ' : ' + str(e))

# Lógica Principal (Manual/Automático)
try:
    if len(sys.argv) > 1:
        conectar()
        iniciar(sys.argv[1])
        disconnect()
    else:
        if os.path.exists(apps_file):
            conectar()
            f = open(apps_file, 'r')
            for line in f:
                app_name = line.strip()
                if app_name and not app_name.startswith('#'):
                    iniciar(app_name)
            f.close()
            disconnect()
except Exception, e:
    print('Error general: ' + str(e))
exit()
