resource "aws_lb" "alb" {
  name               = "ecs-node-nginx"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnets#trava o LB na SUbnet publica 

}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 3000
  protocol          = "HTTP"
 
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alvo.arn
  }
}

resource "aws_lb_target_group" "alvo" {
  name     = "ecs-node-nginx"
  port     = 3000
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = module.vpc.vpc_id
}

output "IP" {
  value = aws_lb.alb.dns_name
}