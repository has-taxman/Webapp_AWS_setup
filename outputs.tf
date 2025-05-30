# Output the DNS of the ALB which serves as the entry point to your application.
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.load_balancer.alb_dns_name
}

# Output the RDS instance endpoint.
output "db_endpoint" {
  description = "Endpoint of the RDS database"
  value       = module.database.db_endpoint
}

output "bastion_sg_id" {
  description = "Security Group ID for bastion host"
  value       = module.security_groups.bastion_sg_id
}