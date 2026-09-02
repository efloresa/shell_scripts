
# $Header: elimina_logs.sh 
# *=====================================================+
# |  Autor - ERIK.FLORES                               |
# |  Cargo - Administrador de base de datos            |
# +=====================================================+
# |                                                    |
# | DESCRIPTION                                        |
# |     Eliminar archivos .log y .out de mas de 7 dias |
# | PLATFORM                                           |
# |     Linux/Solaris/HP-UX                            |
# |                                                    |
# +=====================================================+

#!/usr/bin/ksh
 

echo inicio: `date`

# Borrando registros con mas de 7 dias de antiguedad
find /u02/app/Middleware/ATMDomain/servers/*/logs/*.log* -mtime +7 -exec rm {} \;
find /u02/app/Middleware/ATMDomain/servers/*/logs/*.out* -mtime +7 -exec rm {} \;

echo fin: `date`


