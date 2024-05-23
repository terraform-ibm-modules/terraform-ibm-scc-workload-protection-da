########################################################################################################################
# Common variables
########################################################################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The API Key to use for IBM Cloud."
  sensitive   = true
}

variable "use_existing_resource_group" {
  type        = bool
  description = "Whether to use an existing resource group."
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "The name of a new or an existing resource group in which to provision resources to. If prefix input variable is passed then it will get prefixed infront of the value in the format of '<prefix>-value'."
}

variable "existing_monitoring_crn" {
  type        = string
  nullable    = true
  default     = null
  description = "(Optional) The CRN of an existing IBM Cloud Monitoring instance. Used to send all COS bucket request and usage metrics to, as well as SCC workload protection data. Ignored if using existing COS bucket and not provisioning SCC workload protection."
}

variable "prefix" {
  type        = string
  description = "(Optional) Prefix to append to all resources created by this solution."
  default     = null
}

########################################################################################################################
# KMS variables
########################################################################################################################

variable "existing_kms_instance_crn" {
  type        = string
  default     = null
  description = "The CRN of the existed Hyper Protect Crypto Services or Key Protect instance. Only required if not supplying an existing KMS root key and if 'skip_cos_kms_auth_policy' is true."
}

variable "existing_scc_cos_kms_key_crn" {
  type        = string
  default     = null
  description = "(OPTIONAL) The CRN of an existing KMS key to be used to encrypt the SCC COS bucket. If no value is passed, a value must be passed for either the `existing_kms_instance_crn` input variable if you want to create a new key ring and key, or the `existing_scc_cos_bucket_name` input variable if you want to use an existing bucket."
}

variable "kms_endpoint_type" {
  type        = string
  description = "The type of endpoint to be used for commincating with the KMS instance. Allowed values are: 'public' or 'private' (default)"
  default     = "private"
  validation {
    condition     = can(regex("public|private", var.kms_endpoint_type))
    error_message = "The kms_endpoint_type value must be 'public' or 'private'."
  }
}

variable "scc_cos_key_ring_name" {
  type        = string
  default     = "scc-cos-key-ring"
  description = "The name to give the Key Ring which will be created for the SCC COS bucket Key. Not used if supplying an existing Key. If prefix input variable is passed then it will get prefixed infront of the value in the format of '<prefix>-value'."
}

variable "scc_cos_key_name" {
  type        = string
  default     = "scc-cos-key"
  description = "The name to give the Key which will be created for the SCC COS bucket. Not used if supplying an existing Key. If prefix input variable is passed then it will get prefixed infront of the value in the format of '<prefix>-value'."
}

########################################################################################################################
# COS variables
########################################################################################################################

variable "cos_region" {
  type        = string
  default     = "us-south"
  description = "The Cloud Object Storage region."
}

variable "cos_instance_name" {
  type        = string
  default     = "base-security-services-cos"
  description = "The name to use when creating the Cloud Object Storage instance. If prefix input variable is passed then it will get prefixed infront of the value in the format of '<prefix>-value'."
}

variable "cos_instance_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to Cloud Object Storage instance. Only used if not supplying an existing instance."
  default     = []
}

variable "cos_instance_access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the Cloud Object Storage instance. Only used if not supplying an existing instance."
  default     = []
}

variable "scc_cos_bucket_name" {
  type        = string
  default     = "base-security-services-bucket"
  description = "The name to use when creating the SCC Cloud Object Storage bucket (NOTE: bucket names are globally unique). If 'add_bucket_name_suffix' is set to true, a random 4 characters will be added to this name to help ensure bucket name is globally unique. If prefix input variable is passed then it will get prefixed infront of the value in the format of '<prefix>-value'."
}

variable "add_bucket_name_suffix" {
  type        = bool
  description = "Add random generated suffix (4 characters long) to the newly provisioned SCC COS bucket name. Only used if not passing existing bucket. set to false if you want full control over bucket naming using the 'scc_cos_bucket_name' variable."
  default     = true
}

variable "scc_cos_bucket_access_tags" {
  type        = list(string)
  default     = []
  description = "Optional list of access tags to be added to the SCC COS bucket."
}

variable "scc_cos_bucket_class" {
  type        = string
  default     = "smart"
  description = "The storage class of the newly provisioned SCC COS bucket. Allowed values are: 'standard', 'vault', 'cold', 'smart' (default value), 'onerate_active'"
  validation {
    condition     = contains(["standard", "vault", "cold", "smart", "onerate_active"], var.scc_cos_bucket_class)
    error_message = "Allowed values for cos_bucket_class are \"standard\", \"vault\",\"cold\", \"smart\", or \"onerate_active\"."
  }
}

variable "existing_cos_instance_crn" {
  type        = string
  nullable    = true
  default     = null
  description = "The CRN of an existing Cloud Object Storage instance. If not supplied, a new instance will be created."
}

variable "existing_scc_cos_bucket_name" {
  type        = string
  nullable    = true
  default     = null
  description = "The name of an existing bucket inside the existing Cloud Object Storage instance to use for SCC. If not supplied, a new bucket will be created."
}

variable "skip_cos_kms_auth_policy" {
  type        = bool
  description = "Set to true to skip the creation of an IAM authorization policy that permits the COS instance created to read the encryption key from the KMS instance. WARNING: An authorization policy must exist before an encrypted bucket can be created"
  default     = false
}

variable "management_endpoint_type_for_bucket" {
  description = "The type of endpoint for the IBM terraform provider to use to manage COS buckets. (`public`, `private` or `direct`). Ensure to enable virtual routing and forwarding (VRF) in your account if using `private`, and that the terraform runtime has access to the the IBM Cloud private network."
  type        = string
  default     = "private"
  validation {
    condition     = contains(["public", "private", "direct"], var.management_endpoint_type_for_bucket)
    error_message = "The specified management_endpoint_type_for_bucket is not a valid selection!"
  }
}

variable "existing_activity_tracker_crn" {
  type        = string
  nullable    = true
  default     = null
  description = "(Optional) The CRN of an existing Activity Tracker instance. Used to send SCC COS bucket log data and all object write events to Activity Tracker. Only used if not supplying an existing COS bucket."
}

########################################################################################################################
# SCC variables
########################################################################################################################

variable "scc_instance_name" {
  type        = string
  default     = "base-security-services-scc"
  description = "The name to give the SCC instance that will be provisioned by this solution. If prefix input variable is passed then it will get prefixed infront of the value in the format of '<prefix>-value'."
}

variable "scc_region" {
  type        = string
  default     = "us-south"
  description = "The region in which to provision SCC resources."
}

variable "skip_scc_cos_auth_policy" {
  type        = bool
  default     = false
  description = "Set to true to skip the creation of an IAM authorization policy that permits the SCC instance created by this solution write access to the COS instance. Only used if `provision_scc_instance` is set to true."
}

variable "scc_service_plan" {
  type        = string
  description = "The service/pricing plan to use when provisioning a new Security Compliance Center instance. Allowed values are: 'security-compliance-center-standard-plan' (default value) and 'security-compliance-center-trial-plan'. Only used if `provision_scc_instance` is set to true."
  default     = "security-compliance-center-standard-plan"
  validation {
    condition     = contains(["security-compliance-center-standard-plan", "security-compliance-center-trial-plan"], var.scc_service_plan)
    error_message = "Allowed values for scc_service_plan are \"security-compliance-center-standard-plan\" and \"security-compliance-center-trial-plan\"."
  }
}

variable "existing_en_crn" {
  type        = string
  nullable    = true
  default     = null
  description = "(Optional) The CRN of an existing Event Notification instance. Used to integrate with SCC."
}

variable "scc_instance_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to SCC instance."
  default     = []
}

variable "skip_scc_workload_protection_auth_policy" {
  type        = bool
  default     = false
  description = "Set to true to skip the creation of an IAM authorization policy that permits the SCC instance created by this solution read access to the workload protection instance. Only used if `provision_scc_workload_protection` is set to true."
}

variable "attachments" {
  type = list(object({
    name            = string
    profile_name    = string
    profile_version = string
    description     = string
    schedule        = optional(string, "daily")
    scope = optional(list(
      object({
        environment = optional(string, "ibm-cloud")
        properties = list(object({
          name  = string
          value = string
        }))
      })
    ))
  }))
  description = "scc attachments"
  default     = []
}

########################################################################################################################
# SCC Workload Protection variables
########################################################################################################################

variable "provision_scc_workload_protection" {
  description = "Whether to provision an SCC Workload Protection instance."
  type        = bool
  default     = true
}

variable "scc_workload_protection_instance_name" {
  description = "The name to give the SCC Workload Protection instance that will be provisioned by this solution. Must begine with a letter. Only used i 'provision_scc_workload_protection' to true. If prefix input variable is passed then it will get prefixed infront of the value in the format of '<prefix>-value'."
  type        = string
  default     = "base-security-services-scc-wp"
}

variable "scc_workload_protection_service_plan" {
  description = "SCC Workload Protection instance service pricing plan. Allowed values are: `free-trial` or `graduated-tier`."
  type        = string
  default     = "graduated-tier"
  validation {
    error_message = "Plan for SCC Workload Protection instances can only be `free-trial` or `graduated-tier`."
    condition = contains(
      ["free-trial", "graduated-tier"],
      var.scc_workload_protection_service_plan
    )
  }
}

variable "scc_workload_protection_instance_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to SCC Workload Protection instance."
  default     = []
}

variable "scc_workload_protection_resource_key_tags" {
  type        = list(string)
  description = "Tags associated with the IBM Cloud SCC WP resource key."
  default     = []
}

variable "scc_workload_protection_access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the SCC WP instance."
  default     = []

  validation {
    condition = alltrue([
      for tag in var.scc_workload_protection_access_tags : can(regex("[\\w\\-_\\.]+:[\\w\\-_\\.]+", tag)) && length(tag) <= 128
    ])
    error_message = "Tags must match the regular expression \"[\\w\\-_\\.]+:[\\w\\-_\\.]+\", see https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#limits for more details"
  }
}
