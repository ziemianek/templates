terraform {
  source = "${find_in_parent_folders("catalog/modules")}//ddb"
}

# Is this a bad practice?
include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

# Can it be done in a nicer way?
inputs = {
  name     = include.root.locals.common_vars.locals.name
  env_type = include.root.locals.env_vars.locals.env_type
}
