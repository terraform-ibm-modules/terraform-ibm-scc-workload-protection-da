#######################################################################################################################
# Validation
#######################################################################################################################

#######################################################################################################################
# Resource Group
#######################################################################################################################

module "resource_group" {
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.1.4"
  resource_group_name          = var.existing_resource_group == false ? var.resource_group_name : null
  existing_resource_group_name = var.existing_resource_group == true ? var.resource_group_name : null
}

#######################################################################################################################
# KMS Key
#######################################################################################################################

# KMS root key for SCC COS bucket
module "kms" {
  providers = {
    ibm = ibm.kms
  }
  count                       = var.existing_scc_cos_kms_key_crn != null || var.existing_scc_cos_bucket_name != null ? 0 : 1 # no need to create any KMS resources if passing an existing key, or bucket
  source                      = "terraform-ibm-modules/kms-all-inclusive/ibm"
  version                     = "4.8.1"
  resource_group_id           = null # rg only needed if creating KP instance
  create_key_protect_instance = false
  region                      = var.kms_region
  existing_kms_instance_guid  = var.existing_kms_guid
  key_ring_endpoint_type      = var.kms_endpoint_type
  key_endpoint_type           = var.kms_endpoint_type
  keys = [
    {
      key_ring_name         = var.scc_cos_key_ring_name
      existing_key_ring     = false
      force_delete_key_ring = true
      keys = [
        {
          key_name                 = var.scc_cos_key_name
          standard_key             = false
          rotation_interval_month  = 3
          dual_auth_delete_enabled = false
          force_delete             = true
        }
      ]
    }
  ]
}

#######################################################################################################################
# COS
#######################################################################################################################

locals {
  scc_cos_kms_key_crn = var.existing_scc_cos_bucket_name != null ? null : var.existing_scc_cos_kms_key_crn != null ? var.existing_scc_cos_kms_key_crn : module.kms[0].keys[format("%s.%s", var.scc_cos_key_ring_name, var.scc_cos_key_name)].crn
  cos_instance_crn    = var.existing_cos_instance_crn != null ? var.existing_cos_instance_crn : module.cos[0].cos_instance_crn
  cos_bucket_name     = var.existing_scc_cos_bucket_name != null ? var.existing_scc_cos_bucket_name : module.cos[0].buckets[var.scc_cos_bucket_name].bucket_name

  activity_tracking = var.existing_activity_tracker_crn != null ? {
    read_data_events     = true
    write_data_events    = true
    activity_tracker_crn = var.existing_activity_tracker_crn
  } : null

  metrics_monitoring = var.existing_monitoring_crn != null ? {
    usage_metrics_enabled   = true
    request_metrics_enabled = true
    metrics_monitoring_crn  = var.existing_monitoring_crn
  } : null
}

module "cos" {
  providers = {
    ibm = ibm.cos
  }
  count                    = var.existing_scc_cos_bucket_name == null ? 1 : 0 # no need to call COS module if consumer is passing existing COS bucket
  source                   = "terraform-ibm-modules/cos/ibm//modules/fscloud"
  version                  = "7.4.1"
  resource_group_id        = module.resource_group.resource_group_id
  create_cos_instance      = var.existing_cos_instance_crn == null ? true : false # don't create instance if existing one passed in
  create_resource_key      = false
  cos_instance_name        = var.cos_instance_name
  cos_tags                 = var.cos_instance_tags
  existing_cos_instance_id = var.existing_cos_instance_crn
  access_tags              = var.cos_instance_access_tags
  cos_plan                 = "standard"
  bucket_configs = [{
    access_tags                   = var.scc_cos_bucket_access_tags
    bucket_name                   = var.scc_cos_bucket_name
    kms_encryption_enabled        = true
    kms_guid                      = var.existing_kms_guid
    kms_key_crn                   = local.scc_cos_kms_key_crn
    skip_iam_authorization_policy = var.skip_cos_kms_auth_policy
    management_endpoint_type      = var.management_endpoint_type_for_bucket
    storage_class                 = var.scc_cos_bucket_class
    resource_instance_id          = local.cos_instance_crn
    region_location               = var.cos_region
    force_delete                  = true
    activity_tracking             = local.activity_tracking
    metrics_monitoring            = local.metrics_monitoring
  }]

}

#######################################################################################################################
# SCC
#######################################################################################################################

module "scc" {
  source                            = "terraform-ibm-modules/scc/ibm"
  version                           = "1.1.1"
  resource_group_id                 = module.resource_group.resource_group_id
  region                            = var.scc_region
  instance_name                     = var.scc_instance_name
  plan                              = var.scc_service_plan
  cos_bucket                        = local.cos_bucket_name
  cos_instance_crn                  = local.cos_instance_crn
  en_instance_crn                   = var.existing_en_crn
  skip_cos_iam_authorization_policy = var.skip_scc_cos_auth_policy
  resource_tags                     = var.scc_instance_tags
}

#######################################################################################################################
# SCC WP
#######################################################################################################################

module "scc_wp" {
  count                         = var.provision_scc_workload_protection ? 1 : 0
  source                        = "terraform-ibm-modules/scc-workload-protection/ibm"
  version                       = "1.2.1"
  name                          = var.scc_wp_instance_name
  region                        = var.scc_region
  resource_group_id             = module.resource_group.resource_group_id
  resource_tags                 = var.scc_wp_instance_tags
  resource_key_name             = var.scc_wp_resource_key_name
  resource_key_tags             = var.scc_wp_resource_key_tags
  cloud_monitoring_instance_crn = var.existing_monitoring_crn
  access_tags                   = var.scc_wp_access_tags
  scc_wp_service_plan           = var.scc_wp_service_plan
}
