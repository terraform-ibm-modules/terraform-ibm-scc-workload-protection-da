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

output "scc_id" {
  description = "SCC instance ID"
  value       = var.existing_scc_instance_crn == null ? module.scc[0].id : var.existing_scc_instance_crn
}

output "scc_guid" {
  description = "SCC instance guid"
  value       = var.existing_scc_instance_crn == null ? module.scc[0].guid : local.existing_scc_instance_guid
}

output "scc_crn" {
  description = "SCC instance CRN"
  value       = var.existing_scc_instance_crn == null ? module.scc[0].crn : var.existing_scc_instance_crn
}

output "scc_name" {
  description = "SCC instance name"
  value       = var.existing_scc_instance_crn == null ? module.scc[0].name : data.ibm_resource_instance.scc_instance[0].name
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

output "scc_profile_attachment_id" {
  description = "List of SCC profile attachment ID"
  value       = [for attachment in module.create_profile_attachment : attachment.id]
}

output "scc_profile_info" {
  description = "SCC profile information"
  value = [
    for attachment in module.create_profile_attachment : {
      name    = attachment.profile.profile_name
      version = attachment.profile.profile_version
    }
  ]
}

########################################################################################################################
# SCC COS
########################################################################################################################

output "scc_cos_kms_key_crn" {
  description = "SCC COS KMS Key CRN"
  # if passing an existing bucket, then no KMS key is in play here, so output will be null
  value = var.existing_scc_cos_bucket_name != null ? null : local.scc_cos_kms_key_crn
}

output "scc_cos_bucket_name" {
  description = "SCC COS bucket name"
  value       = var.existing_scc_cos_bucket_name != null ? var.existing_scc_cos_bucket_name : module.cos[0].buckets[local.scc_cos_bucket_name].bucket_name
}

output "scc_cos_bucket_config" {
  description = "List of buckets created"
  value       = var.existing_scc_cos_bucket_name != null ? null : module.cos[0].buckets[local.scc_cos_bucket_name]
}

output "scc_cos_instance_id" {
  description = "SCC COS instance id"
  value       = var.existing_scc_cos_bucket_name != null ? null : module.cos[0].cos_instance_id
}

output "scc_cos_instance_guid" {
  description = "SCC COS instance guid"
  value       = var.existing_scc_cos_bucket_name != null ? null : module.cos[0].cos_instance_guid
}

output "scc_cos_instance_name" {
  description = "SCC COS instance name"
  value       = var.existing_scc_cos_bucket_name != null ? null : local.cos_instance_name
}

output "scc_cos_instance_crn" {
  description = "SCC COS instance crn"
  value       = var.existing_scc_cos_bucket_name != null ? null : module.cos[0].cos_instance_crn
}

output "scc_cos_resource_keys" {
  description = "List of resource keys"
  value       = var.existing_scc_cos_bucket_name != null ? null : module.cos[0].resource_keys
  sensitive   = true
}
