-- Required:
DEF gcp360_in_target_table   = "&&1."
DEF gcp360_in_source_file    = "&&2."

UNDEF 1 2

DEF gcp360_temp_obj_prefix = "GCP360_TMP_&&gcp360_user_curschema."
DEF gcp360_temp_table = "&&gcp360_temp_obj_prefix._TABLE"
DEF gcp360_temp_clob  = "&&gcp360_temp_obj_prefix._CLOB"
DEF gcp360_temp_check = "&&gcp360_temp_obj_prefix._CHECK"
DEF gcp360_temp_view  = "&&gcp360_temp_obj_prefix._VIEW"
DEF gcp360_temp_index = "&&gcp360_temp_obj_prefix._INDEX"
-- DEF gcp360_temp_exttab = 'GCP360_EXTTAB'
-- DEF gcp360_temp_extout = 'file.txt'

-- Creating Table Message
SET TERM ON
PRO Creating table &&gcp360_in_target_table.
@@&&fc_set_term_off.

-- Start SPOOL to log file
@@&&fc_spool_start.
SET ECHO OFF FEED ON VER ON HEAD ON SERVEROUT ON
SPO &&gcp360_log_json. APP;

PRO ----------------------------------------------------------------------------

PRO Converting "&&gcp360_in_source_file." to "&&gcp360_in_target_table.".

PRO ----------------------------------------------------------------------------

SET ECHO ON TIMING ON

-- DBMS_JSON can't run for another user. Go back to Current User:
ALTER SESSION SET CURRENT_SCHEMA=&&gcp360_user_session.;

-- Drop table
BEGIN EXECUTE IMMEDIATE 'DROP TABLE "&&gcp360_temp_table." PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Create table
CREATE TABLE "&&gcp360_temp_table." (
  "&&gcp360_temp_clob." CLOB,
  CONSTRAINT "&&gcp360_temp_check." CHECK ("&&gcp360_temp_clob." IS JSON)
)
COMPRESS NOMONITORING
LOB("&&gcp360_temp_clob.") STORE AS SECUREFILE (COMPRESS HIGH)
&&gcp360_loc_code. TABLESPACE &&gcp360_temp_tablespace.
;

DECLARE
  l_bfile              BFILE;
  l_blob               BLOB;
  l_uncompressed_blob  BLOB;

  l_dest_offset INTEGER := 1;
  l_src_offset  INTEGER := 1;
BEGIN
  dbms_lob.createtemporary(lob_loc => l_blob, cache => true, dur => dbms_lob.call);

&&gcp360_loc_code. l_bfile := BFILENAME('&&gcp360_obj_dir.', '&&gcp360_in_source_file.');
&&gcp360_loc_code. DBMS_LOB.fileopen(l_bfile, DBMS_LOB.file_readonly);

&&gcp360_loc_code. DBMS_LOB.loadfromfile(l_blob, l_bfile, DBMS_LOB.getlength(l_bfile));

  -- DBMS_LOB.loadblobfromfile (
  --   dest_lob    => l_blob,
  --   src_bfile   => l_bfile,
  --   amount      => DBMS_LOB.lobmaxsize,
  --   dest_offset => l_dest_offset,
  --   src_offset  => l_src_offset);

&&gcp360_loc_code. DBMS_LOB.fileclose(l_bfile);

&&gcp360_adb_code.  l_blob := DBMS_CLOUD.GET_OBJECT(
&&gcp360_adb_code.       credential_name => '&&gcp360_adb_cred.',
&&gcp360_adb_code.       object_uri => '&&gcp360_adb_uri.&&gcp360_in_source_file.');

  -- FUNCTION GET_OBJECT RETURNS BLOB
  -- Argument Name			Type			In/Out Default?
  -- ------------------------------ ----------------------- ------ --------
  -- CREDENTIAL_NAME		VARCHAR2		IN     DEFAULT
  -- OBJECT_URI			VARCHAR2		IN
  -- STARTOFFSET			NUMBER			IN     DEFAULT
  -- ENDOFFSET			NUMBER			IN     DEFAULT
  -- COMPRESSION			VARCHAR2		IN     DEFAULT

  IF SUBSTR('&&gcp360_in_source_file.',-3,3) = '.gz'
  THEN
    -- Uncompress the data.
    l_uncompressed_blob := UTL_COMPRESS.lz_uncompress (src => l_blob);
    -- Display lengths.
    DBMS_OUTPUT.put_line('Compressed Length  : ' || LENGTH(l_blob));
    DBMS_OUTPUT.put_line('Uncompressed Length: ' || LENGTH(l_uncompressed_blob));
  ELSE
    DBMS_OUTPUT.put_line('Original Length  : ' || LENGTH(l_blob));
    l_uncompressed_blob := l_blob;
  END IF;

  INSERT INTO "&&gcp360_temp_table." ("&&gcp360_temp_clob.")
  SELECT to_clob(l_uncompressed_blob, 871, 'text/json') FROM dual;

  COMMIT;

  -- Free temporary BLOBs.             
  DBMS_LOB.FREETEMPORARY(l_blob);
  DBMS_LOB.FREETEMPORARY(l_uncompressed_blob);

END;
/

-- Drop index
BEGIN EXECUTE IMMEDIATE 'DROP INDEX "&&gcp360_temp_index."'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Create index
CREATE SEARCH INDEX "&&gcp360_temp_index."
ON "&&gcp360_temp_table." ("&&gcp360_temp_clob.") FOR JSON
PARAMETERS ('SEARCH_ON NONE DATAGUIDE ON');
-- If you get a bug in this creation with 00001: unique constraint (CTXSYS.DRC$IDX_ , best thing to do is reacreate the whole schema.

EXEC DBMS_STATS.GATHER_INDEX_STATS(USER, '&&gcp360_temp_index.', estimate_percent => 99);

INSERT /*+ APPEND */ INTO &&gcp360_user_curschema.."&&gcp360_obj_metadata."
  (source, jpath, type, tlength, pref_col_name, frequency, low_value, high_value, num_nulls, last_analyzed)
WITH dg_t AS (
  SELECT DBMS_JSON.get_index_dataguide(
         '&&gcp360_temp_table.',
         '&&gcp360_temp_clob.',
         DBMS_JSON.format_flat) AS dg_doc
  FROM   dual
)
SELECT '&&gcp360_in_source_file.' source, jt.*
FROM   dg_t,
       json_table(dg_doc, '$[*]'
         COLUMNS
           jpath         VARCHAR2(200) PATH '$."o:path"',
           type          VARCHAR2(10)  PATH '$."type"',
           tlength       NUMBER        PATH '$."o:length"',
           pref_col_name VARCHAR2(100) PATH '$."o:preferred_column_name"',
           frequency     NUMBER        PATH '$."o:frequency"',
           low_value     VARCHAR2(25)  PATH '$."o:low_value"',
           high_value    VARCHAR2(25)  PATH '$."o:high_value"',
           num_nulls     NUMBER        PATH '$."o:num_nulls"',
           last_analyzed VARCHAR2(20)  PATH '$."o:last_analyzed"') jt
ORDER BY jt.jpath;

COMMIT;

-- Rename Columns
DECLARE
  V_NEW_COLNAME VARCHAR2(1000);
  V_COL_TYPE NUMBER(2);
BEGIN
  -- Type 'object' and 'array' are renamed after cause they will probably not appear in final view and could be renamed before a important type.
  FOR I IN (select jpath, type, count(*) over (partition by UPPER(jpath),source,type) tot
            from   &&gcp360_user_curschema.."&&gcp360_obj_metadata."
            where  source = '&&gcp360_in_source_file.'
            order by decode(type,'null',4,'object',3,'array',2,1)
            )
  LOOP
    CASE i.type
      WHEN 'array'   THEN V_COL_TYPE := DBMS_JSON.TYPE_ARRAY;
      WHEN 'boolean' THEN V_COL_TYPE := DBMS_JSON.TYPE_BOOLEAN;
      WHEN 'object'  THEN V_COL_TYPE := DBMS_JSON.TYPE_OBJECT;
      WHEN 'null'    THEN V_COL_TYPE := DBMS_JSON.TYPE_NULL;
      WHEN 'number'  THEN V_COL_TYPE := DBMS_JSON.TYPE_NUMBER;
      WHEN 'string'  THEN V_COL_TYPE := DBMS_JSON.TYPE_STRING;
      ELSE V_COL_TYPE:=0;
    END CASE;
    V_NEW_COLNAME := i.jpath;
    V_NEW_COLNAME := REGEXP_REPLACE(V_NEW_COLNAME,'^\$\.','');
    V_NEW_COLNAME := REGEXP_REPLACE(V_NEW_COLNAME,'^\.','');
    V_NEW_COLNAME := REPLACE(V_NEW_COLNAME,'-','_');
    V_NEW_COLNAME := REPLACE(V_NEW_COLNAME,'.','$');
    V_NEW_COLNAME := REPLACE(V_NEW_COLNAME,'/','$');
    V_NEW_COLNAME := REPLACE(V_NEW_COLNAME,'[*]','');
    V_NEW_COLNAME := REPLACE(V_NEW_COLNAME,'"','');
    V_NEW_COLNAME := NVL(V_NEW_COLNAME,'root$data');
    IF i.tot = 1 THEN V_NEW_COLNAME := UPPER(V_NEW_COLNAME); END IF;
    --DBMS_OUTPUT.PUT_LINE('DBMS_JSON.RENAME_COLUMN(''&&gcp360_temp_table.'', ''&&gcp360_temp_clob.'', ''' || i.jpath || ''', ' || V_COL_TYPE || ', ''' || V_NEW_COLNAME || ''')');
    BEGIN
      -- Json accepts columns with same name and different types. Only first rename will work.
      DBMS_JSON.RENAME_COLUMN('&&gcp360_temp_table.', '&&gcp360_temp_clob.', i.jpath, V_COL_TYPE, V_NEW_COLNAME);
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: DBMS_JSON.RENAME_COLUMN(''&&gcp360_temp_table.'', ''&&gcp360_temp_clob.'', ''' || i.jpath || ''', ' || V_COL_TYPE || ', ''' || V_NEW_COLNAME || ''')');
    END;
  END LOOP;
END;
/

-- Update Metadata Table
MERGE INTO &&gcp360_user_curschema.."&&gcp360_obj_metadata." t1
USING (
  WITH dg_t AS (
    SELECT DBMS_JSON.get_index_dataguide(
           '&&gcp360_temp_table.',
           '&&gcp360_temp_clob.',
           DBMS_JSON.format_flat) AS dg_doc
    FROM   dual
  )
  SELECT jt.jpath, jt.type, jt.pref_col_name
  FROM   dg_t,
         json_table(dg_doc, '$[*]'
           COLUMNS
             jpath         VARCHAR2(200) PATH '$."o:path"',
             type          VARCHAR2(10)  PATH '$."type"',
             pref_col_name VARCHAR2(100) PATH '$."o:preferred_column_name"') jt
) t2
ON (t1.jpath=t2.jpath and t1.type=t2.type and t1.source='&&gcp360_in_source_file.')
WHEN MATCHED THEN
UPDATE SET new_col_name = t2.pref_col_name;

COMMIT;

-- Drop view
BEGIN EXECUTE IMMEDIATE 'DROP VIEW "&&gcp360_temp_view."'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Create view.
DECLARE
   empty_data_guide EXCEPTION;
   PRAGMA EXCEPTION_INIT(empty_data_guide , -40591);
BEGIN
  DBMS_JSON.CREATE_VIEW_ON_PATH(
    viewname  => '&&gcp360_temp_view.',
    tablename => '&&gcp360_temp_table.',
    jcolname  => '&&gcp360_temp_clob.',
    path =>      '$',
    frequency =>  0);
EXCEPTION
  WHEN empty_data_guide THEN
    DBMS_OUTPUT.PUT_LINE('Empty JSON.'); -- handle the error
END;
/

-- Just to print the code on log file for troubleshooting.
SET PAGES 0
SET LONG 2000000000
SELECT DBMS_METADATA.GET_DDL('VIEW','&&gcp360_temp_view.') VIEW_CODE
FROM DUAL
WHERE EXISTS (SELECT 1
              FROM   USER_VIEWS
              WHERE  VIEW_NAME = '&&gcp360_temp_view.');
SET PAGES &&moat369_def_sql_maxrows.

ALTER SESSION SET CURRENT_SCHEMA=&&gcp360_user_curschema.;

-- Drop Target Table
BEGIN EXECUTE IMMEDIATE 'DROP TABLE "&&gcp360_in_target_table." PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE TABLE "&&gcp360_in_target_table."
&&gcp360_tab_compression. NOMONITORING
AS
SELECT *
FROM   &&gcp360_user_session.."&&gcp360_temp_view.";

-- Add mandatory columns that may not be mapped when resource is not being used.
DECLARE
  V_COL_TYPE VARCHAR2(30);
  V_EXISTS NUMBER := 0;
  V_SQL VARCHAR2(500);
BEGIN
  FOR I IN (SELECT t1.source,
                   t1.jpath,
                   t1.type,
                   t1.new_col_name,
                   (select table_name
                    from   all_tables
                    where  owner = '&&gcp360_user_curschema.'
                    and    table_name = '&&gcp360_in_target_table.') table_name,
                   rank() over (partition by t1.source order by t1.jpath) ord_cols,
                   count(1) over (partition by t1.source) tot_cols
            FROM   "&&gcp360_obj_jsoncols." t1
            WHERE  t1.source = '&&gcp360_in_source_file.'
            AND    NOT EXISTS (SELECT 1
                               FROM   "&&gcp360_obj_metadata." t2
                               WHERE  t1.source = t2.source
                               AND    t1.jpath = t2.jpath
                               AND    t1.type = t2.type
                               )
            AND    NOT EXISTS (SELECT 1
                               FROM   "&&gcp360_obj_metadata." t2
                               WHERE  t1.source = t2.source
                               AND    t1.new_col_name = t2.new_col_name
                               )
            ORDER BY t1.source,t1.jpath
           )
  LOOP
    IF I.TABLE_NAME IS NULL AND I.ord_cols=1 THEN
      BEGIN
        V_SQL := 'CREATE TABLE "&&gcp360_in_target_table." AS SELECT 1 "DUMMY" FROM DUAL WHERE 1=2';
        EXECUTE IMMEDIATE V_SQL;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_SQL);
      END;
    END IF;
    BEGIN
      CASE i.type
        WHEN 'number'  THEN V_COL_TYPE := 'NUMBER(1)';
        WHEN 'string'  THEN V_COL_TYPE := 'VARCHAR2(1)';
        WHEN 'boolean' THEN V_COL_TYPE := 'VARCHAR2(1)';
        ELSE V_COL_TYPE:=0;
      END CASE;
      INSERT INTO "&&gcp360_obj_metadata." (source,jpath,type,new_col_name) values (i.source,i.jpath,i.type,i.new_col_name);
      V_SQL := 'alter table "&&gcp360_in_target_table." add "' || i.new_col_name || '" ' || V_COL_TYPE;
      EXECUTE IMMEDIATE V_SQL;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_SQL);
    END;
    IF I.TABLE_NAME IS NULL AND I.ord_cols=I.tot_cols THEN
      BEGIN
        V_SQL := 'ALTER TABLE "&&gcp360_in_target_table." DROP COLUMN "DUMMY"';
        EXECUTE IMMEDIATE V_SQL;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ERROR: ' || V_SQL);
      END;
    END IF;
  END LOOP;
END;
/

-- Mark created columns on Metadata
UPDATE &&gcp360_user_curschema.."&&gcp360_obj_metadata." t1
SET created_on_table = 'Y'
WHERE EXISTS
(SELECT 1
   FROM all_tab_columns t2
  WHERE t1.source = '&&gcp360_in_source_file.'
    AND t2.owner = '&&gcp360_user_curschema.'
    AND t2.table_name = '&&gcp360_in_target_table.'
    AND t1.new_col_name = t2.column_name);

-- Remove null columns that are mapped to another type.
BEGIN
  FOR I IN (SELECT t1.new_col_name
            FROM   "&&gcp360_obj_metadata." t1
            WHERE  t1.source='&&gcp360_in_source_file.'
            AND    t1.type='null'
            AND    EXISTS (SELECT 1
                           FROM   "&&gcp360_obj_metadata." t2
                           WHERE  t2.source = t1.source
                           AND    NOT( t2.jpath = t1.jpath AND t2.type = t1.type )
                           AND    t2.jpath like t1.jpath || '%'
                          )
           )
  LOOP
    BEGIN
      EXECUTE IMMEDIATE 'alter table "&&gcp360_in_target_table." set unused ("' || I.NEW_COL_NAME || '")';
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: alter table "&&gcp360_in_target_table." set unused ("' || I.NEW_COL_NAME || '")');
    END;
  END LOOP;
END;
/

-- Clean

-- EXEC UTL_FILE.FREMOVE ('&&gcp360_obj_dir.', '&&gcp360_temp_extout.');

BEGIN EXECUTE IMMEDIATE 'DROP VIEW &&gcp360_user_session.."&&gcp360_temp_view."'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
DROP TABLE &&gcp360_user_session.."&&gcp360_temp_table." PURGE;

-- DROP TABLE &&gcp360_user_curschema.."&&gcp360_temp_exttab." PURGE;

-- Close SPOOL to log file
SPO OFF;
@@&&fc_spool_end.

SET TIMING OFF

UNDEF gcp360_temp_obj_prefix
UNDEF gcp360_temp_table
UNDEF gcp360_temp_clob
UNDEF gcp360_temp_check
UNDEF gcp360_temp_view
UNDEF gcp360_temp_index
-- UNDEF gcp360_temp_exttab

UNDEF gcp360_in_source_file
UNDEF gcp360_in_target_table