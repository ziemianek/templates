# Set common variables for the environment. This is automatically pulled in in the root root.hcl configuration to
# configure the remote state bucket and is accessible as inputs in child units.
locals {
  env_type = "dev"

  env_tags = {
    Environment = local.env_type
  }
}
