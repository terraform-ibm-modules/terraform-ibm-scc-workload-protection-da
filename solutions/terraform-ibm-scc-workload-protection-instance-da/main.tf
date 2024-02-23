########################################################################################################################
# Security and Compliance Center Workload Protection Instance
########################################################################################################################

module "scc_wp" {
  source                        = "terraform-ibm-modules/scc-workload-protection/ibm"
  name                          = ${var.name}
  region                        = ${var.region}
  resource_group_id             = ${var.resource_group_id}
  access_tags                   = ${var.access_tags}
  resource_tags                 = ${var.resource_tags}
  resource_key_name             = ${var.resource_key_name}
  resource_key_tags             = ${var.resource_key_tags}
  cloud_monitoring_instance_crn = ${var.cloud_monitoring_instance_crn}
  scc_wp_service_plan           = ${var.scc_wp_service_plan}
}