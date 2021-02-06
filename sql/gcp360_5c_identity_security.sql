-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_table_loader. 'GCP_ACTIVE_DIRECTORY_DOMAINS'
@@&&fc_table_loader. 'GCP_AUTH'
@@&&fc_table_loader. 'GCP_IAM_ROLES'
@@&&fc_table_loader. 'GCP_IAM_SERVICE_ACCOUNTS_KEYS'
@@&&fc_table_loader. 'GCP_IAM_SERVICE_ACCOUNTS'
@@&&fc_table_loader. 'GCP_IAM_WORKLOAD_IDENTITY_POOLS_PROVIDERS'
@@&&fc_table_loader. 'GCP_IAM_WORKLOAD_IDENTITY_POOLS'
@@&&fc_table_loader. 'GCP_IDENTITY_GROUPS_MEMBERSHIPS'
@@&&fc_table_loader. 'GCP_ACCESS_CONTEXT_MANAGER_CLOUD_BINDINGS'
@@&&fc_table_loader. 'GCP_ACCESS_CONTEXT_MANAGER_LEVELS_CONDITIONS'
@@&&fc_table_loader. 'GCP_ACCESS_CONTEXT_MANAGER_LEVELS'
@@&&fc_table_loader. 'GCP_ACCESS_CONTEXT_MANAGER_PERIMETERS_DRY_RUN'
@@&&fc_table_loader. 'GCP_ACCESS_CONTEXT_MANAGER_PERIMETERS'
@@&&fc_table_loader. 'GCP_ACCESS_CONTEXT_MANAGER_POLICIES'
@@&&fc_table_loader. 'GCP_RESOURCE_MANAGER_FOLDERS'
@@&&fc_table_loader. 'GCP_RESOURCE_MANAGER_ORG_POLICIES'
@@&&fc_table_loader. 'GCP_SECRETS_LOCATIONS'
@@&&fc_table_loader. 'GCP_SECRETS_VERSIONS'
@@&&fc_table_loader. 'GCP_SECRETS'
-----------------------------------------

DEF title = 'Active Directory Domains'
DEF main_table = 'GCP_ACTIVE_DIRECTORY_DOMAINS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ACTIVE_DIRECTORY_DOMAINS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Auth'
DEF main_table = 'GCP_AUTH'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_AUTH t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Iam Roles'
DEF main_table = 'GCP_IAM_ROLES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_IAM_ROLES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Iam Service Accounts Keys'
DEF main_table = 'GCP_IAM_SERVICE_ACCOUNTS_KEYS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_IAM_SERVICE_ACCOUNTS_KEYS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Iam Service Accounts'
DEF main_table = 'GCP_IAM_SERVICE_ACCOUNTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_IAM_SERVICE_ACCOUNTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Iam Workload Identity Pools Providers'
DEF main_table = 'GCP_IAM_WORKLOAD_IDENTITY_POOLS_PROVIDERS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_IAM_WORKLOAD_IDENTITY_POOLS_PROVIDERS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Iam Workload Identity Pools'
DEF main_table = 'GCP_IAM_WORKLOAD_IDENTITY_POOLS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_IAM_WORKLOAD_IDENTITY_POOLS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Identity Groups Memberships'
DEF main_table = 'GCP_IDENTITY_GROUPS_MEMBERSHIPS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_IDENTITY_GROUPS_MEMBERSHIPS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Access Context Manager Cloud Bindings'
DEF main_table = 'GCP_ACCESS_CONTEXT_MANAGER_CLOUD_BINDINGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ACCESS_CONTEXT_MANAGER_CLOUD_BINDINGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Access Context Manager Levels Conditions'
DEF main_table = 'GCP_ACCESS_CONTEXT_MANAGER_LEVELS_CONDITIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ACCESS_CONTEXT_MANAGER_LEVELS_CONDITIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Access Context Manager Levels'
DEF main_table = 'GCP_ACCESS_CONTEXT_MANAGER_LEVELS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ACCESS_CONTEXT_MANAGER_LEVELS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Access Context Manager Perimeters Dry Run'
DEF main_table = 'GCP_ACCESS_CONTEXT_MANAGER_PERIMETERS_DRY_RUN'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ACCESS_CONTEXT_MANAGER_PERIMETERS_DRY_RUN t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Access Context Manager Perimeters'
DEF main_table = 'GCP_ACCESS_CONTEXT_MANAGER_PERIMETERS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ACCESS_CONTEXT_MANAGER_PERIMETERS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Access Context Manager Policies'
DEF main_table = 'GCP_ACCESS_CONTEXT_MANAGER_POLICIES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ACCESS_CONTEXT_MANAGER_POLICIES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Resource Manager Folders'
DEF main_table = 'GCP_RESOURCE_MANAGER_FOLDERS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_RESOURCE_MANAGER_FOLDERS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Resource Manager Org Policies'
DEF main_table = 'GCP_RESOURCE_MANAGER_ORG_POLICIES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_RESOURCE_MANAGER_ORG_POLICIES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Secrets Locations'
DEF main_table = 'GCP_SECRETS_LOCATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SECRETS_LOCATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Secrets Versions'
DEF main_table = 'GCP_SECRETS_VERSIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SECRETS_VERSIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Secrets'
DEF main_table = 'GCP_SECRETS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SECRETS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

