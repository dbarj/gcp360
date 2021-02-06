-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_table_loader. 'GCP360_RESTYPES'
-----------------------------------------

DEF title = 'Resource Types'
DEF main_table = 'GCP360_RESTYPES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP360_RESTYPES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Json Metadata'
DEF main_table = '&&gcp360_obj_metadata.'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   "&&gcp360_obj_metadata." t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'IaaS Pricing'
DEF main_table = '&&gcp360_obj_pricing.'

BEGIN
  :sql_text := q'{
SELECT SUBJECT,
       LIC_TYPE,
       INST_TYPE,
       TO_CHAR(CEIL(PAYG*100)/100,'999G990D99') PAYG_US$,
       TO_CHAR(CEIL(MF*100)/100,'999G990D99') MF_US$
FROM   "&&gcp360_obj_pricing." t1
}';
END;
/
DEF foot = '* US$ values base url: &&gcp360_pricing_url.<br> US$ values base date: &&gcp360_pricing_date.<br>';
@@&&skip_billing_sql.&&9a_pre_one.
@@&&fc_reset_defs.

-----------------------------------------