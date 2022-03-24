module "Prod" {
    source = "../infra"
    
    name-registry = "prod"
    name-registry2 = "prod2"
    cargoIAM = "producao"
    ambiente = "producao"
}
output "ip_alb" {
  value = module.Prod.IP
}

