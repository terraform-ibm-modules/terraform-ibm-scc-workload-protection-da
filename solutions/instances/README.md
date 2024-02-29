# Security and Compliance Center instances solution

This solution supports the following:
- Creating a new resource group, or taking in an existing one.
- Provisioning and configuring of a Security and Compliance Center instance.
- Provisioning of a COS instance and KMS encrypted bucket which is required to store Security and Compliance Center data.
- Provisioning and configuring of a Security and Compliance Center Workload Protection instance.

**NB:** This solution is not intended to be called by one or more other modules since it contains a provider configurations, meaning it is not compatible with the `for_each`, `count`, and `depends_on` arguments. For more information see [Providers Within Modules](https://developer.hashicorp.com/terraform/language/modules/develop/providers)

## Known limitations
There is currently a known issue with the IBM provider (https://github.com/IBM-Cloud/terraform-provider-ibm/issues/5131) where the provider is always trying to use the `us-south` endpoint when trying to configure the SCC instance, even if the instance is not in `us-south`. You will see the following error on apply:
```
│ Error: UpdateSettingsWithContext failed The requested resource was not found
```
As a workaround, you can set the following environment variable before running apply:
```
export IBMCLOUD_SCC_API_ENDPOINT=https://REGION.compliance.cloud.ibm.com
```
where `REGION` is the value you have set for the modules `region` input variable.

<<-- TODO: Add Diagram -->>
