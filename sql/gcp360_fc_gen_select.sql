-- This code will generate a default "SELECT * FROM" query based on table of parameter 1 and put this query into parameter 2 variable.
-- If parameter 3 is defined, it will order by this parameter. If param1 is a CDB view, con_id will be the first order by clause.
DEF in_table    = '&1.'
DEF in_variable = '&2.'

UNDEF 1 2

VAR OCI360_TAG_COLS CLOB;

BEGIN
  SELECT LISTAGG(DBMS_ASSERT.ENQUOTE_NAME(COLUMN_NAME),',' || CHR(10) || '       ')
           WITHIN GROUP(ORDER BY COLUMN_ID)
  INTO  :OCI360_TAG_COLS
  FROM  USER_TAB_COLUMNS
  WHERE TABLE_NAME='&&in_table.'
  AND   COLUMN_NAME NOT LIKE '%$%';
END;
/

BEGIN
  :&&in_variable. := q'{
SELECT DISTINCT
       }' || :OCI360_TAG_COLS || q'{
FROM   &&in_table. t1
}';
END;
/

UNDEF in_table in_variable