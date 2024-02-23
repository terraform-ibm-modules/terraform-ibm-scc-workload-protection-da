########################################################################################################################
# Security and Compliance Center Workload Protection Agents
########################################################################################################################

module "scc_wp_agent {
    source             = "terraform-ibm-modules/scc-workload-protection-agent/ibm"
    access_key         = ${var.access_key}
    cluster_name       = ${var.cluster_name}
    region             = ${var.region}
    endpoint_type      = ${var.endpoint_type}
    name               = ${var.name}
    namespace          = ${var.namespace}
}