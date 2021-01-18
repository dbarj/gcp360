-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_json_loader. 'GCP_META_APIS_COLLECTIONS'
@@&&fc_json_loader. 'GCP_META_APIS_DISCOVERY'
@@&&fc_json_loader. 'GCP_META_APIS_MESSAGES'
@@&&fc_json_loader. 'GCP_META_APIS_METHODS'
@@&&fc_json_loader. 'GCP_META_APIS'
@@&&fc_json_loader. 'GCP_META_CACHE_COMPLETERS'
@@&&fc_json_loader. 'GCP_META_CACHE'
@@&&fc_json_loader. 'GCP_META_CLI_TREES'
-----------------------------------------

DEF title = 'Meta Apis Collections'
DEF main_table = 'GCP_META_APIS_COLLECTIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_META_APIS_COLLECTIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Meta Apis Discovery'
DEF main_table = 'GCP_META_APIS_DISCOVERY'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_META_APIS_DISCOVERY t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Meta Apis Messages'
DEF main_table = 'GCP_META_APIS_MESSAGES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_META_APIS_MESSAGES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Meta Apis Methods'
DEF main_table = 'GCP_META_APIS_METHODS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_META_APIS_METHODS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Meta Apis'
DEF main_table = 'GCP_META_APIS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_META_APIS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Meta Cache Completers'
DEF main_table = 'GCP_META_CACHE_COMPLETERS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_META_CACHE_COMPLETERS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Meta Cache'
DEF main_table = 'GCP_META_CACHE'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_META_CACHE t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Meta Cli Trees'
DEF main_table = 'GCP_META_CLI_TREES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_META_CLI_TREES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------