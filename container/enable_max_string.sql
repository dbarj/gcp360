whenever sqlerror exit sql.sqlcode
conn / as sysdba
col name new_v pdb_name nopri
select name from v$pdbs where CON_ID=3;
alter session set container=&&pdb_name.;
undef pdb_name
col name clear
shutdown immediate;
startup upgrade;
alter system set MAX_STRING_SIZE='EXTENDED' scope=both;
@?/rdbms/admin/utl32k.sql
shutdown immediate;
startup;
@?/rdbms/admin/utlrp.sql
exit