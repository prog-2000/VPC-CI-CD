module "vpc" {
  source          = "./modules/VPC"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "security_group" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source          = "./modules/EC2"
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = module.vpc.private_subnet_ids[0]
  security_groups = [module.security_group.ec2_sg_id]
  ec2_names       = var.ec2_names
}

module "alb" {
  source               = "./modules/load_balancer"
  security_group_id    = module.security_group.ec2_sg_id
  load_balancer_sg_id  = module.security_group.alb_sg_id
  public_subnets       = module.vpc.public_subnet_ids
  vpc_id               = module.vpc.vpc_id
  target_instance      = module.ec2.instance_ids[0]
}
