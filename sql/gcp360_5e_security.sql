-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_json_loader. 'GCP_ASSET_FEEDS'
@@&&fc_json_loader. 'GCP_SCC_ASSETS'
@@&&fc_json_loader. 'GCP_SCC_FINDINGS'
@@&&fc_json_loader. 'GCP_SCC_NOTIFICATIONS'
-----------------------------------------

DEF title = 'Asset Feeds'
DEF main_table = 'GCP_ASSET_FEEDS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ASSET_FEEDS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Scc Assets'
DEF main_table = 'GCP_SCC_ASSETS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SCC_ASSETS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Scc Findings'
DEF main_table = 'GCP_SCC_FINDINGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SCC_FINDINGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Scc Notifications'
DEF main_table = 'GCP_SCC_NOTIFICATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SCC_NOTIFICATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------