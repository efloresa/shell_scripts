
# $Header: kill_snipped.sh 
# *====================================================================================+
# |  Author - DBACLASS ADMIN TEAM 
# |                                                       |
# +====================================================================================+
# |
# | DESCRIPTION
# |     Kill the snipped session in database
# | PLATFORM
# |     Linux/Solaris/HP-UX

# +===========================================================================+
#!/usr/bin/ksh
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.4/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export ORACLE_SID=srvbdatm
export LOG_PATH=/datos/atm_jobs/control_sessions/LOG
rm -f $LOG_PATH/snip_kill.sql

sqlplus -s /nolog << EOF
connect / as sysdba 
select count(*) from v\$session where status='SNIPED';
spool $LOG_PATH/session_sniped.log 
set lines 200 pages 1500 long 99999999
alter session set nls_date_format='DD-MON-YYYY HH24:MI';
select sysdate from dual;
select sid,serial#,username,machine,logon_time,module from v\$session where status='SNIPED';
spool off;
set head off;
set feed off;
set pages 0;
spool $LOG_PATH/snip_kill.sql
select 'alter system kill session '''||sid||','||serial#||''' immediate;' from v\$session where status='SNIPED' ;
spool off;
@"$LOG_PATH/snip_kill.sql"
exit;

!
date
EOF


