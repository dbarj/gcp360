-- Required:
DEF gcp360_in_target_table   = "&&1."
UNDEF 1

----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Rename Target Table

BEGIN
  IF '&&gcp360_in_target_table.' IN ('GCP360_INSTANCES','GCP360_VOLUMES','GCP360_SECLISTS')
  THEN
    EXECUTE IMMEDIATE 'DROP TABLE "&&gcp360_in_target_table._PREV" PURGE';
  END IF;
EXCEPTION
  WHEN OTHERS
    THEN NULL;
END;
/

BEGIN
  IF '&&gcp360_in_target_table.' IN ('GCP360_INSTANCES','GCP360_VOLUMES','GCP360_SECLISTS')
  THEN
    EXECUTE IMMEDIATE 'ALTER TABLE "&&gcp360_in_target_table." RENAME TO "&&gcp360_in_target_table._PREV"';
  END IF;
EXCEPTION
  WHEN OTHERS
    THEN NULL;
END;
/

UNDEF gcp360_in_target_table