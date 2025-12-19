locals {
    name = "jubio"

    aws_region = "eu-central-1"

    common_tags = {
        App                 = local.name
        Owner               = "Ziemi" 
        ManagedByTerragrunt = "True"
    }
}
