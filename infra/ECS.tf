module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  name = var.ambiente
  container_insights = true
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE"
    }
  ]
}
resource "aws_ecs_task_definition" "NODE-API" {
  family                   = "NODE-API"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.cargo.arn
  container_definitions    = jsonencode(
[
  {
    "name"= "prod"
    "image"= "276835127725.dkr.ecr.us-west-2.amazonaws.com/prod:v1"
    "cpu"= 512
    "memory"= 1024
    "essential"= true
    "portMappings" = [
        {
          "containerPort" = 3000
          "hostPort "     = 3000
        }
      ]
  },
  
  {
    "name"= "prod2"
    "image"= "276835127725.dkr.ecr.us-west-2.amazonaws.com/prod2:v1"
    "cpu"= 512
    "memory"= 1024
    "essential"= true
    "portMappings" = [
        {
          "containerPort" = 80
          "hostPort "     = 80
        }
      ]
  }
  
]
  )
}

resource "aws_ecs_service" "NODE-API" {
  name            = "NODE-API"
  cluster         = module.ecs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.NODE-API.arn
  desired_count   = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.alvo.arn
    container_name   = "prod"
    container_port   = 3000
  }

  network_configuration {
    subnets= module.vpc.private_subnets
    security_groups = [aws_security_group.private.id]
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight = "1"
  }
}