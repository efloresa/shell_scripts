
# $Header: iniciar_servicios.sh
# *=====================================================+
# |  Autor - ERIK.FLORES                               |
# |  Cargo - Administrador de base de datos            |
# +=====================================================+
# |                                                    |
# | DESCRIPTION                                        |
# |     Iniciar servicios de weblogic                  |
# | PLATFORM                                           |
# |     Linux/Solaris/HP-UX                            |
# |                                                    |
# +=====================================================+

#!/usr/bin/ksh

echo inicio: `date`

echo $NODEMGR_HOME
echo $DOMAIN_HOME

#nohup $NODEMGR_HOME/startNodeManager.sh > /dev/null 2>&1 &
nohup $DOMAIN_HOME/startWebLogic.sh > /dev/null 2>&1 &

echo fin: `date`



