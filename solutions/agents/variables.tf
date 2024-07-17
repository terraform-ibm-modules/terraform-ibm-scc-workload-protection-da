########################################################################################################################
# Common variables
########################################################################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key to deploy resources."
  sensitive   = true
}

########################################################################################################################
# SCC Workload Protection Agent variables
########################################################################################################################

variable "name" {
  type        = string
  description = "The Helm release name."
  default     = "ibm-scc-wp-agent"
}

variable "namespace" {
  type        = string
  description = "The namespace of the Workload Protection agent."
  default     = "ibm-scc-wp"
}

variable "cluster_name" {
  type        = string
  description = "The cluster name to add the Workload Protection agent to."
}

variable "access_key" {
  type        = string
  description = "The Workload Protection instance access key."
  sensitive   = true
}

variable "region" {
  type        = string
  description = "The region where the Workload Protection instance is created."
}

variable "endpoint_type" {
  type        = string
  description = "The endpoint for the Workload Protection service. Possible values: `public`, `private.`"
  default     = "private"
  validation {
    error_message = "The specified endpoint_type can be private or public only."
    condition     = contains(["private", "public"], var.endpoint_type)
  }
}

variable "deployment_tag" {
  type        = string
  description = "A global tag that is included in the components. The tag represents the mechanism where the components are installed. For example, `terraform` or `local`."
  default     = "terraform"
}

variable "kspm_deploy" {
  type        = bool
  description = "Whether to deploy the Workload Protection Kubernetes Security Posture Management component."
  default     = true
}

variable "node_analyzer_deploy" {
  type        = bool
  description = "Whether to deploy the Workload Protection node analyzer component."
  default     = true
}

variable "host_scanner_deploy" {
  type        = bool
  description = "Whether to deploy the Workload Protection host scanner component. Applies only if `node_analyzer_deploy` is true."
  default     = true
}

variable "cluster_scanner_deploy" {
  type        = bool
  description = "Whether to deploy the Workload Protection cluster scanner component."
  default     = true
}


variable "cluster_endpoint_type" {
  type        = string
  description = "The endpoint for the cluster. Possible values: `public`, `private.`"
  default     = "private"
  validation {
    error_message = "The specified cluster_endpoint_type can be private or public only."
    condition     = contains(["private", "public"], var.cluster_endpoint_type)
  }
}
