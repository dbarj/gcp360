-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_json_loader. 'GCP_DNS_DNS_KEYS'
@@&&fc_json_loader. 'GCP_DNS_DOMAINS_LIST_USER_VERIFIED'
@@&&fc_json_loader. 'GCP_DNS_MANAGED_ZONES'
@@&&fc_json_loader. 'GCP_DNS_POLICIES'
@@&&fc_json_loader. 'GCP_DNS_PROJECT_INFO'
@@&&fc_json_loader. 'GCP_DNS_RECORD_SETS_CHANGES'
@@&&fc_json_loader. 'GCP_DNS_RECORD_SETS'
-----------------------------------------

DEF title = 'Dns Dns Keys'
DEF main_table = 'GCP_DNS_DNS_KEYS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DNS_DNS_KEYS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Dns Domains List User Verified'
DEF main_table = 'GCP_DNS_DOMAINS_LIST_USER_VERIFIED'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DNS_DOMAINS_LIST_USER_VERIFIED t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Dns Managed Zones'
DEF main_table = 'GCP_DNS_MANAGED_ZONES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DNS_MANAGED_ZONES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Dns Policies'
DEF main_table = 'GCP_DNS_POLICIES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DNS_POLICIES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Dns Project Info'
DEF main_table = 'GCP_DNS_PROJECT_INFO'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DNS_PROJECT_INFO t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Dns Record Sets Changes'
DEF main_table = 'GCP_DNS_RECORD_SETS_CHANGES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DNS_RECORD_SETS_CHANGES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Dns Record Sets'
DEF main_table = 'GCP_DNS_RECORD_SETS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DNS_RECORD_SETS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------