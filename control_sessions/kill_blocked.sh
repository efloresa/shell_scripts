

# -- bash script --
ORACLE_SID=$1; export ORACLE_SID

sqlplus -s -l / as sysdba <<!   

set linesize150   

set heading off   

set feedback off   

spool /tmp/kill_blocked.log   

select p.spid from v$session s, v$process p where s.paddr = p.addr and s.blocking_session is not null;   

spool off   

exit;

!

log=/tmp/kill_blocked.log

if [ `cat $log|wc -l` -gt0 ]; then

while read line; do

kill -9 $line

done < $log

