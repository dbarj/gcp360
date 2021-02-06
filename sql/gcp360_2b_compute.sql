-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_table_loader. 'GCP_COMPUTE_ACCELERATOR_TYPES'
@@&&fc_table_loader. 'GCP_COMPUTE_ADDRESSES'
@@&&fc_table_loader. 'GCP_COMPUTE_BACKEND_BUCKETS'
@@&&fc_table_loader. 'GCP_COMPUTE_BACKEND_SERVICES'
@@&&fc_table_loader. 'GCP_COMPUTE_COMMITMENTS'
@@&&fc_table_loader. 'GCP_COMPUTE_DISK_TYPES'
@@&&fc_table_loader. 'GCP_COMPUTE_DISKS'
@@&&fc_table_loader. 'GCP_COMPUTE_EXTERNAL_VPN_GATEWAYS'
@@&&fc_table_loader. 'GCP_COMPUTE_FIREWALL_RULES'
@@&&fc_table_loader. 'GCP_COMPUTE_FORWARDING_RULES'
@@&&fc_table_loader. 'GCP_COMPUTE_HEALTH_CHECKS'
@@&&fc_table_loader. 'GCP_COMPUTE_HTTP_HEALTH_CHECKS'
@@&&fc_table_loader. 'GCP_COMPUTE_HTTPS_HEALTH_CHECKS'
@@&&fc_table_loader. 'GCP_COMPUTE_IMAGES'
@@&&fc_table_loader. 'GCP_COMPUTE_INSTANCE_GROUPS_MANAGED_INSTANCE_CONFIGS'
@@&&fc_table_loader. 'GCP_COMPUTE_INSTANCE_GROUPS_MANAGED'
@@&&fc_table_loader. 'GCP_COMPUTE_INSTANCE_GROUPS_UNMANAGED'
@@&&fc_table_loader. 'GCP_COMPUTE_INSTANCE_GROUPS'
@@&&fc_table_loader. 'GCP_COMPUTE_INSTANCE_TEMPLATES'
@@&&fc_table_loader. 'GCP_COMPUTE_INSTANCES'
@@&&fc_table_loader. 'GCP_COMPUTE_INTERCONNECTS_ATTACHMENTS'
@@&&fc_table_loader. 'GCP_COMPUTE_INTERCONNECTS_LOCATIONS'
@@&&fc_table_loader. 'GCP_COMPUTE_INTERCONNECTS'
@@&&fc_table_loader. 'GCP_COMPUTE_MACHINE_TYPES'
@@&&fc_table_loader. 'GCP_COMPUTE_NETWORK_ENDPOINT_GROUPS'
@@&&fc_table_loader. 'GCP_COMPUTE_NETWORKS_PEERINGS'
@@&&fc_table_loader. 'GCP_COMPUTE_NETWORKS_SUBNETS'
@@&&fc_table_loader. 'GCP_COMPUTE_NETWORKS_VPC_ACCESS_CONNECTORS'
@@&&fc_table_loader. 'GCP_COMPUTE_NETWORKS_VPC_ACCESS_LOCATIONS'
@@&&fc_table_loader. 'GCP_COMPUTE_NETWORKS'
@@&&fc_table_loader. 'GCP_COMPUTE_OS_CONFIG_PATCH_DEPLOYMENTS'
@@&&fc_table_loader. 'GCP_COMPUTE_OS_CONFIG_PATCH_JOBS'
@@&&fc_table_loader. 'GCP_COMPUTE_OS_LOGIN_SSH_KEYS'
@@&&fc_table_loader. 'GCP_COMPUTE_PACKET_MIRRORINGS'
@@&&fc_table_loader. 'GCP_COMPUTE_PROJECT_INFO'
@@&&fc_table_loader. 'GCP_COMPUTE_REGIONS'
@@&&fc_table_loader. 'GCP_COMPUTE_RESERVATIONS'
@@&&fc_table_loader. 'GCP_COMPUTE_RESOURCE_POLICIES'
@@&&fc_table_loader. 'GCP_COMPUTE_ROUTERS_NATS'
@@&&fc_table_loader. 'GCP_COMPUTE_ROUTERS'
@@&&fc_table_loader. 'GCP_COMPUTE_ROUTES'
@@&&fc_table_loader. 'GCP_COMPUTE_SECURITY_POLICIES'
@@&&fc_table_loader. 'GCP_COMPUTE_SHARED_VPC_ASSOCIATED_PROJECTS'
@@&&fc_table_loader. 'GCP_COMPUTE_SNAPSHOTS'
@@&&fc_table_loader. 'GCP_COMPUTE_SOLE_TENANCY_NODE_GROUPS'
@@&&fc_table_loader. 'GCP_COMPUTE_SOLE_TENANCY_NODE_TEMPLATES'
@@&&fc_table_loader. 'GCP_COMPUTE_SOLE_TENANCY_NODE_TYPES'
@@&&fc_table_loader. 'GCP_COMPUTE_SSL_CERTIFICATES'
@@&&fc_table_loader. 'GCP_COMPUTE_SSL_POLICIES'
@@&&fc_table_loader. 'GCP_COMPUTE_TARGET_GRPC_PROXIES'
@@&&fc_table_loader. 'GCP_COMPUTE_TARGET_HTTP_PROXIES'
@@&&fc_table_loader. 'GCP_COMPUTE_TARGET_HTTPS_PROXIES'
@@&&fc_table_loader. 'GCP_COMPUTE_TARGET_INSTANCES'
@@&&fc_table_loader. 'GCP_COMPUTE_TARGET_POOLS'
@@&&fc_table_loader. 'GCP_COMPUTE_TARGET_SSL_PROXIES'
@@&&fc_table_loader. 'GCP_COMPUTE_TARGET_TCP_PROXIES'
@@&&fc_table_loader. 'GCP_COMPUTE_TARGET_VPN_GATEWAYS'
@@&&fc_table_loader. 'GCP_COMPUTE_TPUS_ACCELERATOR_TYPES'
@@&&fc_table_loader. 'GCP_COMPUTE_TPUS_LOCATIONS'
@@&&fc_table_loader. 'GCP_COMPUTE_TPUS_VERSIONS'
@@&&fc_table_loader. 'GCP_COMPUTE_TPUS'
@@&&fc_table_loader. 'GCP_COMPUTE_URL_MAPS'
@@&&fc_table_loader. 'GCP_COMPUTE_VPN_GATEWAYS'
@@&&fc_table_loader. 'GCP_COMPUTE_VPN_TUNNELS'
@@&&fc_table_loader. 'GCP_COMPUTE_ZONES'
-----------------------------------------

DEF title = 'Compute Accelerator Types'
DEF main_table = 'GCP_COMPUTE_ACCELERATOR_TYPES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_ACCELERATOR_TYPES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Addresses'
DEF main_table = 'GCP_COMPUTE_ADDRESSES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_ADDRESSES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Backend Buckets'
DEF main_table = 'GCP_COMPUTE_BACKEND_BUCKETS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_BACKEND_BUCKETS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Backend Services'
DEF main_table = 'GCP_COMPUTE_BACKEND_SERVICES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_BACKEND_SERVICES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Commitments'
DEF main_table = 'GCP_COMPUTE_COMMITMENTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_COMMITMENTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Disk Types'
DEF main_table = 'GCP_COMPUTE_DISK_TYPES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_DISK_TYPES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Disks'
DEF main_table = 'GCP_COMPUTE_DISKS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_DISKS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute External Vpn Gateways'
DEF main_table = 'GCP_COMPUTE_EXTERNAL_VPN_GATEWAYS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_EXTERNAL_VPN_GATEWAYS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Firewall Rules'
DEF main_table = 'GCP_COMPUTE_FIREWALL_RULES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_FIREWALL_RULES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Forwarding Rules'
DEF main_table = 'GCP_COMPUTE_FORWARDING_RULES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_FORWARDING_RULES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Health Checks'
DEF main_table = 'GCP_COMPUTE_HEALTH_CHECKS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_HEALTH_CHECKS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Http Health Checks'
DEF main_table = 'GCP_COMPUTE_HTTP_HEALTH_CHECKS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_HTTP_HEALTH_CHECKS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Https Health Checks'
DEF main_table = 'GCP_COMPUTE_HTTPS_HEALTH_CHECKS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_HTTPS_HEALTH_CHECKS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Images'
DEF main_table = 'GCP_COMPUTE_IMAGES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_IMAGES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Instance Groups Managed Instance Configs'
DEF main_table = 'GCP_COMPUTE_INSTANCE_GROUPS_MANAGED_INSTANCE_CONFIGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_INSTANCE_GROUPS_MANAGED_INSTANCE_CONFIGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Instance Groups Managed'
DEF main_table = 'GCP_COMPUTE_INSTANCE_GROUPS_MANAGED'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_INSTANCE_GROUPS_MANAGED t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Instance Groups Unmanaged'
DEF main_table = 'GCP_COMPUTE_INSTANCE_GROUPS_UNMANAGED'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_INSTANCE_GROUPS_UNMANAGED t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Instance Groups'
DEF main_table = 'GCP_COMPUTE_INSTANCE_GROUPS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_INSTANCE_GROUPS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Instance Templates'
DEF main_table = 'GCP_COMPUTE_INSTANCE_TEMPLATES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_INSTANCE_TEMPLATES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Instances Raw'
DEF main_table = 'GCP_COMPUTE_INSTANCES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_INSTANCES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Instances'
DEF main_table = 'GCP_COMPUTE_INSTANCES'
@@&&fc_gen_select. '&&main_table.' 'sql_text'
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Interconnects Attachments'
DEF main_table = 'GCP_COMPUTE_INTERCONNECTS_ATTACHMENTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_INTERCONNECTS_ATTACHMENTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Interconnects Locations'
DEF main_table = 'GCP_COMPUTE_INTERCONNECTS_LOCATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_INTERCONNECTS_LOCATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Interconnects'
DEF main_table = 'GCP_COMPUTE_INTERCONNECTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_INTERCONNECTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Machine Types'
DEF main_table = 'GCP_COMPUTE_MACHINE_TYPES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_MACHINE_TYPES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Network Endpoint Groups'
DEF main_table = 'GCP_COMPUTE_NETWORK_ENDPOINT_GROUPS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_NETWORK_ENDPOINT_GROUPS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Networks Peerings'
DEF main_table = 'GCP_COMPUTE_NETWORKS_PEERINGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_NETWORKS_PEERINGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Networks Subnets'
DEF main_table = 'GCP_COMPUTE_NETWORKS_SUBNETS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_NETWORKS_SUBNETS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Networks Vpc Access Connectors'
DEF main_table = 'GCP_COMPUTE_NETWORKS_VPC_ACCESS_CONNECTORS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_NETWORKS_VPC_ACCESS_CONNECTORS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Networks Vpc Access Locations'
DEF main_table = 'GCP_COMPUTE_NETWORKS_VPC_ACCESS_LOCATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_NETWORKS_VPC_ACCESS_LOCATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Networks'
DEF main_table = 'GCP_COMPUTE_NETWORKS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_NETWORKS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Os Config Patch Deployments'
DEF main_table = 'GCP_COMPUTE_OS_CONFIG_PATCH_DEPLOYMENTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_OS_CONFIG_PATCH_DEPLOYMENTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Os Config Patch Jobs'
DEF main_table = 'GCP_COMPUTE_OS_CONFIG_PATCH_JOBS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_OS_CONFIG_PATCH_JOBS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Os Login Ssh Keys'
DEF main_table = 'GCP_COMPUTE_OS_LOGIN_SSH_KEYS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_OS_LOGIN_SSH_KEYS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Packet Mirrorings'
DEF main_table = 'GCP_COMPUTE_PACKET_MIRRORINGS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_PACKET_MIRRORINGS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Project Info'
DEF main_table = 'GCP_COMPUTE_PROJECT_INFO'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_PROJECT_INFO t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Regions'
DEF main_table = 'GCP_COMPUTE_REGIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_REGIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Reservations'
DEF main_table = 'GCP_COMPUTE_RESERVATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_RESERVATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Resource Policies'
DEF main_table = 'GCP_COMPUTE_RESOURCE_POLICIES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_RESOURCE_POLICIES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Routers Nats'
DEF main_table = 'GCP_COMPUTE_ROUTERS_NATS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_ROUTERS_NATS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Routers'
DEF main_table = 'GCP_COMPUTE_ROUTERS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_ROUTERS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Routes'
DEF main_table = 'GCP_COMPUTE_ROUTES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_ROUTES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Security Policies'
DEF main_table = 'GCP_COMPUTE_SECURITY_POLICIES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_SECURITY_POLICIES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Shared Vpc Associated Projects'
DEF main_table = 'GCP_COMPUTE_SHARED_VPC_ASSOCIATED_PROJECTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_SHARED_VPC_ASSOCIATED_PROJECTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Snapshots'
DEF main_table = 'GCP_COMPUTE_SNAPSHOTS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_SNAPSHOTS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Sole Tenancy Node Groups'
DEF main_table = 'GCP_COMPUTE_SOLE_TENANCY_NODE_GROUPS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_SOLE_TENANCY_NODE_GROUPS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Sole Tenancy Node Templates'
DEF main_table = 'GCP_COMPUTE_SOLE_TENANCY_NODE_TEMPLATES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_SOLE_TENANCY_NODE_TEMPLATES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Sole Tenancy Node Types'
DEF main_table = 'GCP_COMPUTE_SOLE_TENANCY_NODE_TYPES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_SOLE_TENANCY_NODE_TYPES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Ssl Certificates'
DEF main_table = 'GCP_COMPUTE_SSL_CERTIFICATES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_SSL_CERTIFICATES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Ssl Policies'
DEF main_table = 'GCP_COMPUTE_SSL_POLICIES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_SSL_POLICIES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Target Grpc Proxies'
DEF main_table = 'GCP_COMPUTE_TARGET_GRPC_PROXIES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_TARGET_GRPC_PROXIES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Target Http Proxies'
DEF main_table = 'GCP_COMPUTE_TARGET_HTTP_PROXIES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_TARGET_HTTP_PROXIES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Target Https Proxies'
DEF main_table = 'GCP_COMPUTE_TARGET_HTTPS_PROXIES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_TARGET_HTTPS_PROXIES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Target Instances'
DEF main_table = 'GCP_COMPUTE_TARGET_INSTANCES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_TARGET_INSTANCES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Target Pools'
DEF main_table = 'GCP_COMPUTE_TARGET_POOLS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_TARGET_POOLS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Target Ssl Proxies'
DEF main_table = 'GCP_COMPUTE_TARGET_SSL_PROXIES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_TARGET_SSL_PROXIES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Target Tcp Proxies'
DEF main_table = 'GCP_COMPUTE_TARGET_TCP_PROXIES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_TARGET_TCP_PROXIES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Target Vpn Gateways'
DEF main_table = 'GCP_COMPUTE_TARGET_VPN_GATEWAYS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_TARGET_VPN_GATEWAYS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Tpus Accelerator Types'
DEF main_table = 'GCP_COMPUTE_TPUS_ACCELERATOR_TYPES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_TPUS_ACCELERATOR_TYPES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Tpus Locations'
DEF main_table = 'GCP_COMPUTE_TPUS_LOCATIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_TPUS_LOCATIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Tpus Versions'
DEF main_table = 'GCP_COMPUTE_TPUS_VERSIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_TPUS_VERSIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Tpus'
DEF main_table = 'GCP_COMPUTE_TPUS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_TPUS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Url Maps'
DEF main_table = 'GCP_COMPUTE_URL_MAPS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_URL_MAPS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Vpn Gateways'
DEF main_table = 'GCP_COMPUTE_VPN_GATEWAYS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_VPN_GATEWAYS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Vpn Tunnels'
DEF main_table = 'GCP_COMPUTE_VPN_TUNNELS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_VPN_TUNNELS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Compute Zones'
DEF main_table = 'GCP_COMPUTE_ZONES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_COMPUTE_ZONES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------