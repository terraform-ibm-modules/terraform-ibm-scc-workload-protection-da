########################################################################################################################
# Provider config
########################################################################################################################

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.scc_workload_protection_instance_region
}

provider "kubernetes" {
  host  = data.ibm_container_cluster_config.cluster_dconfig.host
  token = data.ibm_container_cluster_config.cluster_config.token
}

provider "helm" {
  kubernetes {
    host  = data.ibm_container_cluster_config.cluster_config.host
    token = data.ibm_container_cluster_config.cluster_config.token
  }
}

data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id = var.scc_workload_protection_agent_cluster_name
  config_dir      = "${path.module}/kubeconfig"
  endpoint_type   = "private"
}
