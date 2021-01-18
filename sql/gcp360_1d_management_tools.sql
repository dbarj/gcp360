-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_json_loader. 'GCP_DEBUG_LOGPOINTS'
@@&&fc_json_loader. 'GCP_DEBUG_SNAPSHOTS'
@@&&fc_json_loader. 'GCP_DEBUG_TARGETS'
@@&&fc_json_loader. 'GCP_DEPLOYMENT_MANAGER_DEPLOYMENTS'
@@&&fc_json_loader. 'GCP_DEPLOYMENT_MANAGER_MANIFESTS'
@@&&fc_json_loader. 'GCP_DEPLOYMENT_MANAGER_RESOURCES'
@@&&fc_json_loader. 'GCP_DEPLOYMENT_MANAGER_TYPES'
@@&&fc_json_loader. 'GCP_LOGGING_LOGS'
@@&&fc_json_loader. 'GCP_LOGGING_METRICS'
@@&&fc_json_loader. 'GCP_LOGGING_RESOURCE_DESCRIPTORS'
@@&&fc_json_loader. 'GCP_LOGGING_SINKS'
@@&&fc_json_loader. 'GCP_ORGANIZATIONS'
@@&&fc_json_loader. 'GCP_PROJECTS'
-----------------------------------------

DEF title = 'Debug Logpoints'
DEF main_table = 'GCP_DEBUG_LOGPOINTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DEBUG_LOGPOINTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Debug Snapshots'
DEF main_table = 'GCP_DEBUG_SNAPSHOTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DEBUG_SNAPSHOTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Debug Targets'
DEF main_table = 'GCP_DEBUG_TARGETS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DEBUG_TARGETS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Deployment Manager Deployments'
DEF main_table = 'GCP_DEPLOYMENT_MANAGER_DEPLOYMENTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DEPLOYMENT_MANAGER_DEPLOYMENTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Deployment Manager Manifests'
DEF main_table = 'GCP_DEPLOYMENT_MANAGER_MANIFESTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DEPLOYMENT_MANAGER_MANIFESTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Deployment Manager Resources'
DEF main_table = 'GCP_DEPLOYMENT_MANAGER_RESOURCES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DEPLOYMENT_MANAGER_RESOURCES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Deployment Manager Types'
DEF main_table = 'GCP_DEPLOYMENT_MANAGER_TYPES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_DEPLOYMENT_MANAGER_TYPES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Logging Logs'
DEF main_table = 'GCP_LOGGING_LOGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_LOGGING_LOGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Logging Metrics'
DEF main_table = 'GCP_LOGGING_METRICS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_LOGGING_METRICS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Logging Resource Descriptors'
DEF main_table = 'GCP_LOGGING_RESOURCE_DESCRIPTORS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_LOGGING_RESOURCE_DESCRIPTORS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Logging Sinks'
DEF main_table = 'GCP_LOGGING_SINKS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_LOGGING_SINKS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Organizations'
DEF main_table = 'GCP_ORGANIZATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ORGANIZATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Projects'
DEF main_table = 'GCP_PROJECTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_PROJECTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------