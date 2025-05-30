# Get the latest Amazon Linux 2 AMI for the bastion host
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

#########################################################
# Root Module: Call Child Modules for Each Component
#########################################################

# Call the VPC module.
module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# Bastion host in the public subnet
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id # from step 1
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = module.vpc.public_subnet_ids[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.security_groups.bastion_sg_id] # from step 2

  tags = {
    Name = "MultiTier-Bastion-Host"
  }
}

# Call the Security Groups module.
module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

# Call the Load Balancer module.
module "load_balancer" {
  source         = "./modules/load_balancer"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  alb_sg_id      = module.security_groups.alb_sg_id
}

# Call the Auto Scaling module.
module "autoscaling" {
  source           = "./modules/autoscaling"
  instance_type    = var.instance_type
  key_name         = var.key_name
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnet_ids
  target_group_arn = module.load_balancer.target_group_arn
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size
  instance_sg_id   = module.security_groups.instance_sg_id

# Ensure the NAT Gateway and private-route-table exist & are "available"
  depends_on = [
    module.vpc
  ]
}

# Call the Monitoring module.
module "monitoring" {
  source   = "./modules/monitoring"
  asg_name = module.autoscaling.asg_name
}

# Call the Database module.
module "database" {
  source               = "./modules/database"
  vpc_id               = module.vpc.vpc_id
  private_subnets      = module.vpc.private_subnet_ids
  app_sg_id            = module.security_groups.instance_sg_id # Allow Node.js instances to connect to DB.
  db_engine            = var.db_engine
  db_engine_version    = var.db_engine_version
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
}

