whenever sqlerror exit sql.sqlcode
conn / as sysdba
col name new_v pdb_name nopri
select name from v$pdbs where CON_ID=3;
alter session set container=&&pdb_name.;
undef pdb_name
col name clear
create profile DEFAULT_PASSWORD_NOEXP limit password_life_time unlimited;
create user GCP360 identified by "oracle";
alter user GCP360 default tablespace USERS quota unlimited on USERS profile DEFAULT_PASSWORD_NOEXP;
grant CREATE SESSION, ALTER SESSION, CREATE SEQUENCE, CREATE TABLE, CREATE VIEW to GCP360;
grant SELECT on SYS.GV_$INSTANCE to GCP360;
grant SELECT on SYS.GV_$OSSTAT to GCP360;
grant SELECT on SYS.GV_$SYSTEM_PARAMETER2 to GCP360;
grant SELECT on SYS.V_$DATABASE to GCP360;
grant SELECT on SYS.V_$INSTANCE to GCP360;
grant SELECT on SYS.V_$PARAMETER to GCP360;
grant SELECT on SYS.V_$PARAMETER2 to GCP360;
grant SELECT on SYS.V_$PROCESS to GCP360;
grant SELECT on SYS.V_$SESSION to GCP360;
grant SELECT on SYS.V_$SYSTEM_PARAMETER2 to GCP360;
grant EXECUTE on SYS.DBMS_LOCK to GCP360;
grant EXECUTE on SYS.UTL_FILE to GCP360;
create directory GCP360_DIR as '/u01/gcp360_tool/out/';
grant READ, WRITE, EXECUTE on directory GCP360_DIR to GCP360;
exit