# Inputs for the load balancer module.

variable "vpc_id" {
  description = "VPC ID where the Load Balancer will be created"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security Group ID for the ALB"
  type        = string
}