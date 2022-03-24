resource "aws_security_group" "alb" {
  name        = "alb_ECS"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "tcp_alb" {
  type              = "ingress"
  from_port         =  3000
  to_port           =  3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "saida_alb" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group" "private" {
  name        = "private_ECS"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "input_alb" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.alb.id # requisições, só poderá vir recursos da rede pública, pois tem que passar pelo LB primeiramente
  security_group_id = aws_security_group.private.id
}

resource "aws_security_group_rule" "output_alb" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private.id
}