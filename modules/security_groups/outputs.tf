# Outputs to use the security group IDs in other modules.
output "alb_sg_id" {
  description = "ID of the ALB Security Group"
  value       = aws_security_group.alb_sg.id
}

output "instance_sg_id" {
  description = "ID of the instance Security Group"
  value       = aws_security_group.instance_sg.id
}

# Output the Bastion Security Group ID
output "bastion_sg_id" {
  description = "ID of the Bastion Host Security Group"
  value       = aws_security_group.bastion_sg.id
}