#vpc##
module "vpc" {
  source               = "../modules/vpc"
  vpc_name             = var.vpc_name
  cidr_block           = var.cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidr1 = var.private_subnet_cidr1
  private_subnet_cidr2 = var.private_subnet_cidr2
  availability_zones   = var.availability_zones
  availability_zones1  = var.availability_zones1
  availability_zones2  = var.availability_zones2
}

module "bastion_security_group1" {
  source = "../modules/bastion_security_group"
  vpc_id = module.vpc.vpc_id
}

module "private_security_group" {
  source        = "../modules/private_security_group"
  vpc_id        = module.vpc.vpc_id
  bastion_sg_id = module.bastion_security_group1.bastion_sg_id
}

##keypair##
module "key_pair" {
  source   = "../modules/keypair"
  key_name = var.key_name
}

# ##bastion-server##
module "bastion" {
  source           = "../modules/bastion_server"
  bastion_ami      = var.bastion_ami
  instance_type    = var.instance_type
  bastion_name     = var.bastion_name
  public_subnet_id = module.vpc.public_subnet_ids[0]
  bastion_sg_id    = module.bastion_security_group1.bastion_sg_id
  key_name         = var.key_name
  vpc_id           = module.vpc.vpc_id
}

##private-server##
module "private_server" {
  source            = "../modules/private_server"
  private_ami       = var.private_ami
  private_instance_type     = var.private_instance_type
  private_name      = var.private_name
  private_subnet_id = module.vpc.private_subnet_ids[0]
  private_sg_id     = module.private_security_group.private_sg_id
  key_name          = var.key_name
  vpc_id            = module.vpc.vpc_id
}

##alb-sg##
module "alb_security_group" {
  source        = "../modules/alb_security_group"
  vpc_id        = module.vpc.vpc_id
  private_sg_id = module.private_security_group.private_sg_id
}

##alb##
module "alb" {
  source              = "../modules/alb"
  name                = "my-alb"
  security_groups     = [module.bastion_security_group1.bastion_sg_id, module.private_security_group.private_sg_id]
  subnets             = module.vpc.public_subnet_ids
  vpc_id              = module.vpc.vpc_id
  target_group_name   = "my-targets"
  target_group_port   = 80
  target_instance_ids = [module.bastion.bastion_instance_id, module.private_server.private_instance_id]  # Reference instance IDs from modules
  listener_port       = 80
}

##postgres-rds##
module "db_security_group" {
source        = "../modules/rds_security_group"
vpc_id        = module.vpc.vpc_id
private_sg_id = module.private_security_group.private_sg_id
}

module "rds_postgres" {
source              = "../modules/rds_postgres"
identifier          = var.identifier
allocated_storage   = var.allocated_storage
instance_class      = var.instance_class
db_name             = var.db_name
username            = var.username
security_group_id   = module.db_security_group.db_sg_id
subnet_ids          = module.vpc.private_subnet_ids
subnet_group_name   = "db-private-subnet-group"
}

##s3-bucket##
module "s3_bucket" {
source      = "../modules/s3_backend"
bucket_name = "terraformbucketstate-shobin-8byte-2026" 
tags = {
Name        = "terraform_bucket"
Environment = "management"
}
}