output "access_key" {
  description = "Workload Protection instance access key."
  value       = module.scc_wp_instance.access_key
  sensitive   = true
}

output "cluster_data" {
  value       = module.landing_zone.cluster_data
  description = "Details of OCP cluster."
}

output "workload_cluster_id" {
  value       = lookup([for cluster in module.landing_zone.cluster_data : cluster if strcontains(cluster.resource_group_name, "workload")][0], "id", "")
  description = "ID of the workload cluster."
}

output "workload_cluster_name" {
  value       = [for cluster_name in module.landing_zone.cluster_names : cluster_name if strcontains(cluster_name, "workload")][0]
  description = "Name of the workload cluster."
}

output "cluster_resource_group_id" {
  value       = lookup([for cluster in module.landing_zone.cluster_data : cluster if strcontains(cluster.resource_group_name, "workload")][0], "resource_group_id", "")
  description = "Resource group ID of the workload cluster."
}
