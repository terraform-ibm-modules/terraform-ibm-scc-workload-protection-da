########################################################################################################################
# Outputs
########################################################################################################################

output "resource_group_name" {
  description = "Resource group name"
  value       = module.resource_group.resource_group_name
}

output "resource_group_id" {
  description = "Resource group ID"
  value       = module.resource_group.resource_group_id
}

output "scc_cos_kms_key_crn" {
  description = "SCC COS KMS Key CRN"
  # if passing an existing bucket, then no KMS key is in play here, so output will be null
  value = var.existing_scc_cos_bucket_name != null ? null : local.scc_cos_kms_key_crn
}

output "scc_cos_bucket_name" {
  description = "SCC COS bucket name"
  value       = local.cos_bucket_name
}

output "scc_id" {
  description = "SCC instance ID"
  value       = module.scc.id
}

output "scc_guid" {
  description = "SCC instance guid"
  value       = module.scc.guid
}

output "scc_crn" {
  description = "SCC instance CRN"
  value       = module.scc.crn
}

output "scc_name" {
  description = "SCC instance name"
  value       = module.scc.name
}

output "scc_workload_protection_id" {
  description = "SCC Workload Protection instance ID"
  value       = var.provision_scc_workload_protection ? module.scc_wp[0].id : null
}

output "scc_workload_protection_crn" {
  description = "SCC Workload Protection instance CRN"
  value       = var.provision_scc_workload_protection ? module.scc_wp[0].crn : null
}

output "scc_workload_protection_name" {
  description = "SCC Workload Protection instance name"
  value       = var.provision_scc_workload_protection ? module.scc_wp[0].name : null
}

output "scc_workload_protection_ingestion_endpoint" {
  description = "SCC Workload Protection instance ingestion endpoint"
  value       = var.provision_scc_workload_protection ? module.scc_wp[0].name : null
}

output "scc_workload_protection_api_endpoint" {
  description = "SCC Workload Protection API endpoint"
  value       = var.provision_scc_workload_protection ? module.scc_wp[0].api_endpoint : null
  sensitive   = true
}

output "scc_workload_protection_access_key" {
  description = "SCC Workload Protection access key"
  value       = var.provision_scc_workload_protection ? module.scc_wp[0].access_key : null
  sensitive   = true
}
