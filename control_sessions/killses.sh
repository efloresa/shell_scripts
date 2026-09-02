#!/usr/bin/ksh

export ORACLE_UNQNAME=srvbdatm
export ORACLE_SID=srvbdatm

cd $ORACLE_HOME/bin/

#sqlplus -s /nolog <<EOF > salida.sql
#connect EFLORES/EFLORES
#@sqlses.sql;
#quit;
#EOF

#sqlplus -s /nolog <<EOF 
#connect EFLORES/EFLORES
#@salida.sql;
#quit;
#EOF

resultado=`sqlplus -s 'EFLORES/EFLORES' << EOF > salida.sql
@sqlses.sql;
EOF`

#salida=`sqlplus -s 'EFLORES/EFLORES' << EOF
#@salida.sql
#EOF`

#rm -f salida.sql


