# Input variable for security groups.
variable "vpc_id" {
  description = "The VPC ID where security groups will be created"
  type        = string
}

variable "my_ip_cidr" {
  description = "Your workstation public IP in CIDR notation (for SSH access to bastion)"
  type        = string
  default     = "209.35.71.143/32" # <— replace with your real IP
}