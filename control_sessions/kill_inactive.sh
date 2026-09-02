
# $Header: kill_inactive.sh 
# *====================================================================================+
# |  Author - ERIK.FLORES
# |                                                       |
# +====================================================================================+
# |
# | DESCRIPTION
# |     Kill the inactive session in database 
# | PLATFORM
# |     Linux/Solaris/HP-UX

# +===========================================================================+
#!/usr/bin/ksh
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.4/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export ORACLE_SID=srvbdatm
export LOG_PATH=/datos/atm_jobs/control_sessions/LOG
rm -f $LOG_PATH/inactive_kill.sql

sqlplus -s /nolog << EOF
connect / as sysdba 
select count(*) from v\$session where status='INACTIVE' and logon_time <= SYSDATE - 6/24 and UPPER(username) NOT IN ('SYS','SYSTEM','SYSMAN','DBSNMP','PUBLIC','AXISATM','OUTLN','MDSYS','ORDSYS','ORDPLUGINS','CTXSYS','DSSYS','PERFSTAT','WKPROXY','WKSYS','WDMSYS','XDB','ANONYMOUS','ODM','ODM_MTR','OLAPSYS','TRACESVR','REPADMIN','AURORA$ORB$UNAUTHENTICATED','AURORA$JIS$UTILITY$','OSE$HTTP$ADMIN','BIGB');
spool $LOG_PATH/session_inactive.log 
set lines 200 pages 1500 long 99999999
alter session set nls_date_format='DD-MON-YYYY HH24:MI';
select sysdate from dual;
select sid,serial#,username,machine,logon_time,module from v\$session where status='INACTIVE' and logon_time <= SYSDATE - 6/24 and UPPER(username) NOT IN ('SYS','SYSTEM','SYSMAN','DBSNMP','PUBLIC','AXISATM','OUTLN','MDSYS','ORDSYS','ORDPLUGINS','CTXSYS','DSSYS','PERFSTAT','WKPROXY','WKSYS','WDMSYS','XDB','ANONYMOUS','ODM','ODM_MTR','OLAPSYS','TRACESVR','REPADMIN','AURORA$ORB$UNAUTHENTICATED','AURORA$JIS$UTILITY$','OSE$HTTP$ADMIN','BIGB');
spool off;
set head off;
set feed off;
set pages 0;
spool $LOG_PATH/inactive_kill.sql
select 'alter system kill session '''||sid||','||serial#||''' immediate;' from v\$session where status='INACTIVE' and logon_time <= SYSDATE - 6/24 and UPPER(username) NOT IN ('SYS','SYSTEM','SYSMAN','DBSNMP','PUBLIC','AXISATM','OUTLN','MDSYS','ORDSYS','ORDPLUGINS','CTXSYS','DSSYS','PERFSTAT','WKPROXY','WKSYS','WDMSYS','XDB','ANONYMOUS','ODM','ODM_MTR','OLAPSYS','TRACESVR','REPADMIN','AURORA$ORB$UNAUTHENTICATED','AURORA$JIS$UTILITY$','OSE$HTTP$ADMIN','BIGB');
spool off; 
@"$LOG_PATH/inactive_kill.sql" 
exit;
!
date
EOF


