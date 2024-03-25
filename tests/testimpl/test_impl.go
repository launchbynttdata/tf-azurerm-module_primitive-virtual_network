package common

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

func TestVnet(t *testing.T, ctx types.TestContext) {

	subscriptionId := os.Getenv("AZURE_SUBSCRIPTION_ID")
	if len(subscriptionId) == 0 {
		t.Fatal("AZURE_SUBSCRIPTION_ID environment variable is not set")
	}

	vnetId := terraform.Output(t, ctx.TerratestTerraformOptions(), "vnet_id")
	rgId := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_id")
	vnetName := terraform.Output(t, ctx.TerratestTerraformOptions(), "vnet_name")
	rgName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")
	t.Run("VnetExists", func(t *testing.T) {

		assert.True(t, azure.VirtualNetworkExists(t, vnetName, rgName, subscriptionId), "Virtual Network must exist")
	})
	t.Run("RgExists", func(t *testing.T) {

		assert.True(t, azure.ResourceGroupExists(t, rgName, subscriptionId), "Resource Group must exist")
	})

	t.Run("TfOutputsNotEmpty", func(t *testing.T) {

		assert.NotEmpty(t, vnetId, "VNet ID must not be empty")
		assert.NotEmpty(t, rgId, "Resource Group ID must not be empty")
	})
}
