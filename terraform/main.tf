terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "MY_access_key_here"
  secret_key = "MY__secret_key_here"
  token      = "MY_token_here"
}

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 1.6.0"

  repository_force_delete = true
  repository_name         = "client-repo"
  repository_lifecycle_policy = jsonencode({
    rules = [{
      action       = { type = "expire" }
      description  = "Delete all images except a handful of the newest images"
      rulePriority = 1
      selection = {
        countNumber = 3
        countType   = "imageCountMoreThan"
        tagStatus   = "any"
      }
    }]
  })
}

resource "docker_image" "this" {
  name = format("%v:%v", module.ecr.repository_url, formatdate("YYYY-MM-DD'T'hh-mm-ss", timestamp()))

  build { context = "../" }
}

resource "docker_registry_image" "this" {
  keep_remotely = true
  name          = resource.docker_image.this.name
}


module "ecs" {
 source  = "terraform-aws-modules/ecs/aws"
 version = "~> 4.1.3"

 cluster_name = "client-ecs-cluster"

 fargate_capacity_providers = {
  FARGATE = {
   default_capacity_provider_strategy = {
    base   = 20
    weight = 50
   }
  }
  FARGATE_SPOT = {
   default_capacity_provider_strategy = {
    weight = 50
   }
  }
 }
}



data "aws_iam_role" "ecs_task_execution_role" { name = "ecsTaskExecutionRole" }
resource "aws_ecs_task_definition" "this" {
 container_definitions = jsonencode([{
  environment: [
   { name = "NODE_ENV", value = "production" }
  ],
  essential = true,
  image = resource.docker_registry_image.this.name,
  name = "client-run",
 }])
 cpu = 256
 execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
 family = "family-of-client-tasks"
 memory = 512
 network_mode = "awsvpc"
 requires_compatibilities = ["FARGATE"]
}




resource "aws_ecs_service" "this" {
 cluster = module.ecs.cluster_id
 desired_count = 1
 launch_type = "FARGATE"
 name = "client-service"
 task_definition = resource.aws_ecs_task_definition.this.arn

 lifecycle {
  ignore_changes = [desired_count]
 }

}
