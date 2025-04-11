# Variables required for the database module.

variable "vpc_id" {
  description = "The VPC ID for the RDS deployment"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for the RDS subnet group"
  type        = list(string)
}

variable "app_sg_id" {
  description = "The security group ID for the application (allowed to connect to the database)"
  type        = string
}

variable "db_engine" {
  description = "The database engine (e.g., mysql, postgres)"
  type        = string
}

variable "db_engine_version" {
  description = "The version of the database engine"
  type        = string
}

variable "db_instance_class" {
  description = "Instance class for the database"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage (in GB) for the database instance"
  type        = number
}

variable "db_name" {
  description = "Initial database name"
  type        = string
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
