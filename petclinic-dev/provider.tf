/* terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.37.0"
      region = "ap-south-1"
    }
  }
}
 */
provider "aws" {
  region = var.region
}