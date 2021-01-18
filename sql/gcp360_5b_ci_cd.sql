-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_json_loader. 'GCP_ARTIFACTS_DOCKER_IMAGES'
@@&&fc_json_loader. 'GCP_ARTIFACTS_DOCKER_TAGS'
@@&&fc_json_loader. 'GCP_ARTIFACTS_LOCATIONS'
@@&&fc_json_loader. 'GCP_ARTIFACTS_PACKAGES'
@@&&fc_json_loader. 'GCP_ARTIFACTS_REPOSITORIES'
@@&&fc_json_loader. 'GCP_ARTIFACTS_TAGS'
@@&&fc_json_loader. 'GCP_ARTIFACTS_VERSIONS'
@@&&fc_json_loader. 'GCP_BUILDS'
@@&&fc_json_loader. 'GCP_SCHEDULER_JOBS'
@@&&fc_json_loader. 'GCP_TASKS_LOCATIONS'
@@&&fc_json_loader. 'GCP_TASKS_QUEUES'
@@&&fc_json_loader. 'GCP_TASKS'
-----------------------------------------

DEF title = 'Artifacts Docker Images'
DEF main_table = 'GCP_ARTIFACTS_DOCKER_IMAGES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ARTIFACTS_DOCKER_IMAGES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Artifacts Docker Tags'
DEF main_table = 'GCP_ARTIFACTS_DOCKER_TAGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ARTIFACTS_DOCKER_TAGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Artifacts Locations'
DEF main_table = 'GCP_ARTIFACTS_LOCATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ARTIFACTS_LOCATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Artifacts Packages'
DEF main_table = 'GCP_ARTIFACTS_PACKAGES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ARTIFACTS_PACKAGES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Artifacts Repositories'
DEF main_table = 'GCP_ARTIFACTS_REPOSITORIES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ARTIFACTS_REPOSITORIES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Artifacts Tags'
DEF main_table = 'GCP_ARTIFACTS_TAGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ARTIFACTS_TAGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Artifacts Versions'
DEF main_table = 'GCP_ARTIFACTS_VERSIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ARTIFACTS_VERSIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Builds'
DEF main_table = 'GCP_BUILDS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_BUILDS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Scheduler Jobs'
DEF main_table = 'GCP_SCHEDULER_JOBS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SCHEDULER_JOBS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Tasks Locations'
DEF main_table = 'GCP_TASKS_LOCATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_TASKS_LOCATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Tasks Queues'
DEF main_table = 'GCP_TASKS_QUEUES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_TASKS_QUEUES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Tasks'
DEF main_table = 'GCP_TASKS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_TASKS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------
