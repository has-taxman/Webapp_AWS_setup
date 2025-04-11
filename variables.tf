# Global variables used across modules.

# The AWS region used for deployment.
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

# VPC CIDR block used for our entire environment.
variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

# List of CIDRs for the public subnets. These will host the load balancer.
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# List of CIDRs for the private subnets. These will host your Node.js app instances.
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

# Instance type used by the launch configuration for your Node.js app.
variable "instance_type" {
  description = "EC2 instance type for the Node.js app"
  default     = "t2.micro"
}

# Desired number of instances in your Auto Scaling Group (ASG).
variable "desired_capacity" {
  description = "Desired capacity for the ASG"
  default     = 2
}

# Maximum number of instances in the ASG.
variable "max_size" {
  description = "Maximum size for the ASG"
  default     = 4
}

# Minimum number of instances in the ASG.
variable "min_size" {
  description = "Minimum size for the ASG"
  default     = 1
}

# SSH Key to enable remote connections (if needed).
variable "key_name" {
  description = "SSH key name"
  type        = string
}

# Database configuration variables
variable "db_engine" {
  description = "The database engine to use (mysql or postgres)"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Version of the database engine"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "The database instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "myappdb"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

