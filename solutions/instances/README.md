# Security and Compliance Center instances solution

This solution supports the following:
- Creating a new resource group, or taking in an existing one.
- Provisioning and configuring of a Security and Compliance Center instance.
- Provisioning of a COS instance and KMS encrypted bucket which is required to store Security and Compliance Center data.
- Provisioning and configuring of a Security and Compliance Center Workload Protection instance.

**NB:** This solution is not intended to be called by one or more other modules since it contains a provider configurations, meaning it is not compatible with the `for_each`, `count`, and `depends_on` arguments. For more information see [Providers Within Modules](https://developer.hashicorp.com/terraform/language/modules/develop/providers)

## Current limitation
Currently this solution does not support attaching the Workload Protection instance to the SCC instance. That enhancement is being tracked in https://github.com/terraform-ibm-modules/terraform-ibm-scc-da/issues/23
