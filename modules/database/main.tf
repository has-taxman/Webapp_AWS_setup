#########################################################
# RDS Database Module: Provision a relational database
#########################################################

# Create a DB subnet group from the private subnets.
resource "aws_db_subnet_group" "this" {
  name       = "multi-tier-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "MultiTier-DB-SubnetGroup"
  }
}

# Create a security group for the RDS instance.
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow access to the RDS instance from the application instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306 # Default MySQL port. Change if using PostgreSQL (5432) or adjust accordingly.
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.app_sg_id]
    description     = "Allow MySQL traffic from app instances"
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MultiTier-RDS-SG"
  }
}

# Provision the RDS instance.
resource "aws_db_instance" "this" {
  identifier             = "multi-tier-db"
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false
  multi_az               = false # Set to true for production environments if required.
  skip_final_snapshot    = true  # Change as needed for production environments.
  deletion_protection    = false

  tags = {
    Name = "MultiTier-RDS"
  }
}
