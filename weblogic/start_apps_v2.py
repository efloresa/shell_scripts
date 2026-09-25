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

# Configuracion
apps_file = '/datos/atm_jobs/weblogic/apps_to_manage.txt'
user_config = '/datos/atm_jobs/weblogic/myuserconfig.secure'
user_key = '/datos/atm_jobs/weblogic/myuserkey.secure'
admin_url = 't3://srv00pwla05.atm.local:7001'

def conectar():
    print('Conectando a AdminServer en ' + admin_url + '...')
    connect(userConfigFile=user_config, userKeyFile=user_key, url=admin_url)

def iniciar(app):
    print('\n--- Intentando iniciar: ' + app + ' ---')
    try:
        # Iniciamos la tarea de despliegue
        task = startApplication(app)
        print('Tarea iniciada. Monitoreando progreso...')

        # Bucle de monitoreo síncrono
        while task.running:
            print('Sigue en progreso... Estado: ' + task.state)
            Thread.sleep(3000) # Espera 3 segundos

        if task.completed:
            print('SUCESO: La aplicacion ' + app + ' se inicio correctamente.')
        else:
            print('ADVERTENCIA: La tarea termino con estado: ' + task.state)
            for msg in task.messages:
                print('Detalle: ' + msg)

    except Exception, e:
        error_msg = str(e)
        if "same running task" in error_msg.lower():
            print('AVISO: Ya existe una tarea de inicio en curso para ' + app + '. No se requiere accion.')
        elif "already active" in error_msg.lower():
            print('INFO: La aplicacion ' + app + ' ya se encuentra en estado ACTIVO.')
        else:
            print('ERROR REAL al intentar iniciar ' + app + ': ' + error_msg)

# Logica Principal
try:
    if len(sys.argv) > 1:
        app_manual = sys.argv[1]
        print('MODO MANUAL: Procesando ' + app_manual)
        conectar()
        iniciar(app_manual)
        disconnect()
    else:
        print('MODO AUTOMATICO: Leyendo archivo ' + apps_file)
        if os.path.exists(apps_file):
            conectar()
            f = open(apps_file, 'r')
            for line in f:
                app_name = line.strip()
                if app_name and not app_name.startswith('#'):
                    iniciar(app_name)
            f.close()
            disconnect()
        else:
            print('ERROR: No se encontro el archivo de aplicaciones: ' + apps_file)
except Exception, e:
    print('ERROR GENERAL DEL SCRIPT: ' + str(e))

exit()

