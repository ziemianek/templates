locals {
  tofu_version         = "1.11.1"
  aws_provider_version = "6.27.0"

  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
  env_vars    = read_terragrunt_config(find_in_parent_folders("env_vars.hcl"))

  env_type   = local.env_vars.locals.env_type
  aws_region = local.common_vars.locals.aws_region

  default_tags = merge(
    local.common_vars.locals.common_tags,
    local.env_vars.locals.env_tags
  )
}


# TODO: configure role assumption for opentofu
remote_state {
  backend  = "s3"
  config   = {
    bucket         = "jubio-tfstate-${local.aws_region}-${local.env_type}"
    key            = "${path_relative_to_include()}/tofu.tfstate"
    region         = local.aws_region
    encrypt        = true
    use_lockfile   = true
    s3_bucket_tags = local.default_tags
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"

  default_tags {
    tags = ${jsonencode(local.default_tags)}
  }
}
EOF
}


generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
terraform {
  required_version = "${local.tofu_version}"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "${local.aws_provider_version}"
    }
  }
}
EOF
}
