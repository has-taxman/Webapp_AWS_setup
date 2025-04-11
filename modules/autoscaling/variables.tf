# Variables for the autoscaling module.

# EC2 instance type for the Node.js app
variable "instance_type" {
  description = "EC2 instance type for the Node.js app"
  type        = string
}

# Key name for SSH access
variable "key_name" {
  description = "SSH key name for the EC2 instances"
  type        = string
}

# VPC ID into which the autoscaling instances will be launched.
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

# List of private subnet IDs for the instances.
variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

# Target Group ARN to attach instances for the load balancer
variable "target_group_arn" {
  description = "Target group ARN for the Auto Scaling Group"
  type        = string
}

# Desired capacity of the ASG.
variable "desired_capacity" {
  description = "Desired capacity for the Auto Scaling Group"
  type        = number
}

# Maximum number of instances in the ASG.
variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
}

# Minimum number of instances in the ASG.
variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
}

# Security Group ID to attach to the launch configuration for instance access.
variable "instance_sg_id" {
  description = "Security group ID for the EC2 instances"
  type        = string
}
