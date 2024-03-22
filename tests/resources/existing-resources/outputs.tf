##############################################################################
# Outputs
##############################################################################

output "resource_group_name" {
  description = "Resource group name"
  value       = module.resource_group.resource_group_name
}

output "prefix" {
  value       = var.prefix
  description = "Prefix"
}

output "cos_crn" {
  description = "COS CRN"
  value       = module.cos.cos_instance_crn
}

output "bucket_name" {
  description = "Bucket name"
  value       = module.cos.bucket_name
}

output "monitoring_crn" {
  value       = module.cloud_monitoring.crn
  description = "Monitoring CRN"
}

output "en_crn" {
  description = "Event Notification CRN"
  value       = module.event_notifications.crn
}
