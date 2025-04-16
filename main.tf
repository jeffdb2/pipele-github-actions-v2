terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.1"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.24.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "jrsterraformstate"
    container_name       = "remote-state"
    key                  = "pipeline-github/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      owner     = "jeffersonsantos"
      manage-by = "terraform"
    }
  }
}


provider "azurerm" {
  features {}
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "jrs-remote-state"
    key    = "aws-vpc/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "vnet" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "jrsterraformstate"
    container_name       = "remote-state"
    key                  = "azure-vnet/terraform.tfstate"
  }

}