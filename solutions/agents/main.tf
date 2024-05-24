#######################################################################################################################
# SCC WP Agent
#######################################################################################################################

module "scc_wp_agent" {
  source        = "terraform-ibm-modules/scc-workload-protection-agent/ibm"
  version       = "1.1.3"
  access_key    = var.scc_workload_protection_agent_access_key
  cluster_name  = var.scc_workload_protection_agent_cluster_name
  region        = var.scc_workload_protection_instance_region
  endpoint_type = var.scc_workload_protection_agent_endpoint_type
  name          = var.scc_workload_protection_agent_agent_name
  namespace     = var.scc_workload_protection_agent_agent_namespace
}
