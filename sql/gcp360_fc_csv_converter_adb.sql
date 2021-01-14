-- Required:
DEF gcp360_in_csvconv_p1   = "&&1."
DEF gcp360_in_csvconv_p2   = "&&2."
UNDEF 1 2

DEF gcp360_csv_tablename   = '&&gcp360_in_csvconv_p1.'
DEF gcp360_csv_fileprefx   = '&&gcp360_in_csvconv_p2.'
DEF gcp360_temp_colcontrol = 'GCP360_COL_CONTROL'

DEF fc_csv_converter_loop  = '&&moat369_sw_folder./gcp360_fc_csv_converter_adb_loop.sql'

BEGIN EXECUTE IMMEDIATE 'DROP TABLE "&&gcp360_temp_colcontrol." PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE TABLE "&&gcp360_temp_colcontrol."
(
    CSV_COL_NAME VARCHAR2(200),
    TAB_COL_NAME VARCHAR2(200),
    CONSTRAINT "&&gcp360_temp_colcontrol._PK" PRIMARY KEY (CSV_COL_NAME),
    CONSTRAINT "&&gcp360_temp_colcontrol._UK" UNIQUE (TAB_COL_NAME)
) COMPRESS NOPARALLEL NOMONITORING;

INSERT INTO "&&gcp360_temp_colcontrol." VALUES ('lineItem/referenceNo','lineItem/referenceNo');
COMMIT;

BEGIN EXECUTE IMMEDIATE 'DROP TABLE "&&gcp360_csv_tablename." PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE TABLE "&&gcp360_csv_tablename."
(
  "lineItem/referenceNo" VARCHAR2(4000)
  -- ,CONSTRAINT "&&gcp360_csv_tablename._PK" PRIMARY KEY ("lineItem/referenceNo")
) &&gcp360_tab_compression. NOPARALLEL NOMONITORING;

@@&&fc_def_output_file. step_csv_full_loader 'step_csv_full_loader.sql'
HOS cat "&&gcp360_csv_files." | &&cmd_grep. '&&gcp360_csv_fileprefx.' | &&cmd_awk. '{print("@@&&fc_csv_converter_loop. &&gcp360_csv_tablename. "$1)}' > &&step_csv_full_loader.
@@&&step_csv_full_loader.
@@&&fc_zip_driver_files. &&step_csv_full_loader.
UNDEF step_csv_full_loader

DROP TABLE "&&gcp360_temp_colcontrol." PURGE;

UNDEF gcp360_in_csvconv_p1
UNDEF gcp360_in_csvconv_p2

UNDEF gcp360_csv_tablename
UNDEF gcp360_csv_fileprefx
UNDEF gcp360_temp_colcontrol

UNDEF fc_csv_converter_loop