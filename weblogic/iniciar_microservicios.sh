
# $Header: iniciar_microservicios.sh
# *===========================================================+
# |  Autor - ERIK.FLORES                                     |
# |  Cargo - Administrador de base de datos                  |
# +===========================================================+
# |                                                          |
# | DESCRIPTION                                              |
# |     Iniciar microservicios                               |
# | PLATFORM                                                 |
# |     Linux/Solaris/HP-UX                                  |
# |                                                          |
# +===========================================================+

#!/usr/bin/ksh

#DOMAIN_BASE=/u02/app/Middleware
#HOME=/home/oracle

echo $DOMAIN_BASE

cd $DOMAIN_BASE/microservicios/servicios/
java -jar servicios-1.0.jar --jasypt.encryptor.password=ATM2020 &

#cd $DOMAIN_BASE/microservicios/validacionPago/
#java -jar Jobs-1.0.jar --jasypt.encryptor.password=ATM2021 &

cd $DOMAIN_BASE/microservicios/Tramas/
java -jar trama-services-1.0.jar & 

cd $DOMAIN_BASE/microservicios/convenios/
java -jar convenios-services-1.1.jar & 

cd $HOME


