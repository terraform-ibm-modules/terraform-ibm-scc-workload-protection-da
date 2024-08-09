########################################################################################################################
# Provider config
########################################################################################################################

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

provider "kubernetes" {
  host  = data.ibm_container_cluster_config.cluster_config.host
  token = data.ibm_container_cluster_config.cluster_config.token
}

provider "helm" {
  kubernetes {
    host                   = data.ibm_container_cluster_config.cluster_config.host
    token                  = data.ibm_container_cluster_config.cluster_config.token
    cluster_ca_certificate = data.ibm_container_cluster_config.cluster_config.ca_certificate
  }
}

data "ibm_container_vpc_cluster" "cluster" {
  name              = var.cluster_name
  wait_till         = var.wait_till
  wait_till_timeout = var.wait_till_timeout
}

data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id = data.ibm_container_vpc_cluster.cluster.name
  config_dir      = "${path.module}/kubeconfig"
  endpoint_type   = var.cluster_endpoint_type
}
