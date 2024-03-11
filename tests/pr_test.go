// Tests in this file are run in the PR pipeline
package test

import (
	"log"
	"math/rand"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testschematic"
)

const resourceGroup = "geretain-test-resources"
const instanceFlavorDir = "solutions/instances"

// Define a struct with fields that match the structure of the YAML data
const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"

// Current supported SCC region
var validRegions = []string{
	"us-south",
	"eu-de",
	"ca-tor",
	"eu-es",
}

var permanentResources map[string]interface{}

func TestMain(m *testing.M) {
	// Read the YAML file contents
	var err error
	permanentResources, err = common.LoadMapFromYaml(yamlLocation)
	if err != nil {
		log.Fatal(err)
	}

	os.Exit(m.Run())
}

func TestInstancesInSchematics(t *testing.T) {
	t.Parallel()

	var region = validRegions[rand.Intn(len(validRegions))]

	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing: t,
		Prefix:  "scc-da",
		TarIncludePatterns: []string{
			"*.tf",
			instanceFlavorDir + "/*.tf",
		},
		ResourceGroup:          resourceGroup,
		TemplateFolder:         instanceFlavorDir,
		Tags:                   []string{"test-schematic"},
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 60,
	})

	// Workaround for https://github.com/IBM-Cloud/terraform-provider-ibm/issues/5131
	options.AddWorkspaceEnvVar("IBMCLOUD_SCC_API_ENDPOINT", "https://private."+region+".compliance.cloud.ibm.com", false, false)

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "resource_group_name", Value: options.Prefix, DataType: "string"},
		{Name: "existing_kms_guid", Value: permanentResources["hpcs_south"], DataType: "string"},
		{Name: "kms_region", Value: "us-south", DataType: "string"}, // KMS instance is in us-south
		{Name: "scc_region", Value: region, DataType: "string"},
		{Name: "cos_region", Value: region, DataType: "string"},
		{Name: "cos_instance_tags", Value: options.Tags, DataType: "list(string)"},
		{Name: "scc_instance_tags", Value: options.Tags, DataType: "list(string)"},
		{Name: "scc_wp_instance_tags", Value: options.Tags, DataType: "list(string)"},
		{Name: "scc_wp_resource_key_tags", Value: options.Tags, DataType: "list(string)"},
		{Name: "scc_cos_bucket_access_tags", Value: permanentResources["accessTags"], DataType: "list(string)"},
		{Name: "scc_wp_access_tags", Value: permanentResources["accessTags"], DataType: "list(string)"},
		{Name: "cos_instance_access_tags", Value: permanentResources["accessTags"], DataType: "list(string)"},
	}

	err := options.RunSchematicTest()
	assert.Nil(t, err, "This should not have errored")
}

func TestRunUpgradeInstances(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: "solutions/instances",
		Prefix:       "scc-ins-upg",
	})

	options.TerraformVars = map[string]interface{}{
		"resource_group_name":                 options.Prefix,
		"existing_kms_guid":                   permanentResources["hpcs_south"],
		"kms_endpoint_type":                   "public",
		"kms_region":                          "us-south",
		"management_endpoint_type_for_bucket": "public",
	}

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}
