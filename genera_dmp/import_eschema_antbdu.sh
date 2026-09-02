
cd /cloudfs/RESPALDO/

impdp userid=\'/ as sysdba\' directory=RESPALDOS dumpfile=EXPORT_SCHEMA_ANTBDU%U.dmp LOGFILE=IMPORT_SCHEMA_ANTBDU.log TABLE_EXISTS_ACTION=REPLACE

