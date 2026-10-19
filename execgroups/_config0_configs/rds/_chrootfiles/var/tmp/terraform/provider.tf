# AWS Provider Configuration
# Configures the AWS provider with region and default tagging strategy

# Local block to sort tags for consistent ordering
locals {
  # Convert user-provided tags map to sorted list
  sorted_cloud_tags = [
    for k in sort(keys(var.cloud_tags)) : {
      key   = k
      value = var.cloud_tags[k]
    }
  ]

  # Create a sorted and consistent map of all tags
  all_tags = merge(
    # Convert sorted list back to map
    { for item in local.sorted_cloud_tags : item.key => item.value },
    {
      # Tag indicating resources are managed by config0
      orchestrated_by = "config0"
    }
  )
}

provider "aws" {
  # Region where AWS resources will be created
  region = var.aws_default_region

  # Default tags applied to all resources with consistent ordering
  default_tags {
    tags = local.all_tags
  }

  # Optional: Configure tags to be ignored by the provider
  ignore_tags {
    # Uncomment and customize if specific tags should be ignored
    # keys = ["TemporaryTag", "AutomationTag"]
  }
}

# Terraform Version Configuration
# Specifies the required Terraform and provider versions
terraform {
  # The rds module 7.2.2 needs OpenTofu or Terraform >= 1.11.1
  required_version = ">= 1.11.1"

  # Required providers with version constraints
  required_providers {
    aws = {
      source = "hashicorp/aws" # AWS provider source
      # The rds module 7.2.2 needs >= 6.28. No lock file pins the provider,
      # so this stays on 6.x.
      version = "~> 6.28"
    }
  }
}