resource "aws_iam_role" "cargo" {
  name = "${var.cargoIAM}_cargo"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ec2.amazonaws.com","ecs-tasks.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "ecs_ecr" {
  name = "test_policy"
  role = aws_iam_role.cargo.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            "ecr:GetAuthorizationToken", #pegar o token de autorização para acessar o ECR
            "ecr:BatchCheckLayerAvailability", #checar a disponibilidade dos layers que a imagem docker são divididas
            "ecr:GetDownloadUrlForLayer", #pegar uma URL de download para cada layer, para que possa utilizar a imagem 
            "ecr:BatchGetImage", #pegar a imagem de forma geral
            "logs:CreateLogStream",#criar os logs
            "logs:PutLogEvents"#colocar os eventos nos logs
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "perfil" {
  name = "${var.cargoIAM}_perfil"
  role = aws_iam_role.cargo.name
}
