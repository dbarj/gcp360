-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_json_loader. 'GCP_CONTAINER_BINAUTHZ_ATTESTATIONS'
@@&&fc_json_loader. 'GCP_CONTAINER_BINAUTHZ_ATTESTORS'
@@&&fc_json_loader. 'GCP_CONTAINER_CLUSTERS'
@@&&fc_json_loader. 'GCP_CONTAINER_HUB_MEMBERSHIPS'
@@&&fc_json_loader. 'GCP_CONTAINER_IMAGES'
@@&&fc_json_loader. 'GCP_CONTAINER_NODE_POOLS'
-----------------------------------------

DEF title = 'Container Binauthz Attestations'
DEF main_table = 'GCP_CONTAINER_BINAUTHZ_ATTESTATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_CONTAINER_BINAUTHZ_ATTESTATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Container Binauthz Attestors'
DEF main_table = 'GCP_CONTAINER_BINAUTHZ_ATTESTORS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_CONTAINER_BINAUTHZ_ATTESTORS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Container Clusters'
DEF main_table = 'GCP_CONTAINER_CLUSTERS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_CONTAINER_CLUSTERS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Container Hub Memberships'
DEF main_table = 'GCP_CONTAINER_HUB_MEMBERSHIPS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_CONTAINER_HUB_MEMBERSHIPS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Container Images'
DEF main_table = 'GCP_CONTAINER_IMAGES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_CONTAINER_IMAGES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Container Node Pools'
DEF main_table = 'GCP_CONTAINER_NODE_POOLS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_CONTAINER_NODE_POOLS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------