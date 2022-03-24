resource "aws_ecr_repository" "repos" {
  name                 = var.name-registry
}
resource "aws_ecr_repository" "repos2" {
  name                 = var.name-registry2
}