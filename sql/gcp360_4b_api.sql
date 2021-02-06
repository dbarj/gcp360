-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_table_loader. 'GCP_APIGEE_APIS'
@@&&fc_table_loader. 'GCP_APIGEE_APPLICATIONS'
@@&&fc_table_loader. 'GCP_APIGEE_DEPLOYMENTS'
@@&&fc_table_loader. 'GCP_APIGEE_DEVELOPERS'
@@&&fc_table_loader. 'GCP_APIGEE_ENVIRONMENTS'
@@&&fc_table_loader. 'GCP_APIGEE_ORGANIZATIONS'
@@&&fc_table_loader. 'GCP_APIGEE_PRODUCTS'
@@&&fc_table_loader. 'GCP_ENDPOINTS_CONFIGS'
@@&&fc_table_loader. 'GCP_ENDPOINTS_SERVICES'
@@&&fc_table_loader. 'GCP_RECOMMENDER_INSIGHTS'
@@&&fc_table_loader. 'GCP_RECOMMENDER_RECOMMENDATIONS'
@@&&fc_table_loader. 'GCP_SERVICES_PEERED_DNS_DOMAINS'
@@&&fc_table_loader. 'GCP_SERVICES_VPC_PEERINGS'
@@&&fc_table_loader. 'GCP_SERVICES'
-----------------------------------------

DEF title = 'Apigee Apis'
DEF main_table = 'GCP_APIGEE_APIS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_APIGEE_APIS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Apigee Applications'
DEF main_table = 'GCP_APIGEE_APPLICATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_APIGEE_APPLICATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Apigee Deployments'
DEF main_table = 'GCP_APIGEE_DEPLOYMENTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_APIGEE_DEPLOYMENTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Apigee Developers'
DEF main_table = 'GCP_APIGEE_DEVELOPERS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_APIGEE_DEVELOPERS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Apigee Environments'
DEF main_table = 'GCP_APIGEE_ENVIRONMENTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_APIGEE_ENVIRONMENTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Apigee Organizations'
DEF main_table = 'GCP_APIGEE_ORGANIZATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_APIGEE_ORGANIZATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Apigee Products'
DEF main_table = 'GCP_APIGEE_PRODUCTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_APIGEE_PRODUCTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Endpoints Configs'
DEF main_table = 'GCP_ENDPOINTS_CONFIGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ENDPOINTS_CONFIGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Endpoints Services'
DEF main_table = 'GCP_ENDPOINTS_SERVICES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_ENDPOINTS_SERVICES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Recommender Insights'
DEF main_table = 'GCP_RECOMMENDER_INSIGHTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_RECOMMENDER_INSIGHTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Recommender Recommendations'
DEF main_table = 'GCP_RECOMMENDER_RECOMMENDATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_RECOMMENDER_RECOMMENDATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Services Peered Dns Domains'
DEF main_table = 'GCP_SERVICES_PEERED_DNS_DOMAINS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SERVICES_PEERED_DNS_DOMAINS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Services Vpc Peerings'
DEF main_table = 'GCP_SERVICES_VPC_PEERINGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SERVICES_VPC_PEERINGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Services'
DEF main_table = 'GCP_SERVICES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_SERVICES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------
