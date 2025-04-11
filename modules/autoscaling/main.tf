#########################################################
# Launch Template and Auto Scaling Group for Node.js
#########################################################

# Get the latest Amazon Linux 2 AMI.
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Launch Template for the Node.js app instances.
resource "aws_launch_template" "app_lt" {
  name_prefix           = "multi-tier-lt-"
  image_id              = data.aws_ami.amazon_linux.id
  instance_type         = var.instance_type
  key_name              = var.key_name
  vpc_security_group_ids = [var.instance_sg_id]  # Updated argument

  # User data must be provided as a base64-encoded string.
user_data = base64encode(<<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo amazon-linux-extras install -y nodejs git
  # Clone your repository into /home/ec2-user/app
  git clone https://github.com/your-username/your-repo.git /home/ec2-user/app
  cd /home/ec2-user/app
  npm install
  nohup node index.js > /var/log/app.log 2>&1 &
EOF
)

}

# Auto Scaling Group for the Node.js instances.
resource "aws_autoscaling_group" "app_asg" {
  name                      = "multi-tier-asg"
  vpc_zone_identifier       = var.private_subnets
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_type         = "EC2"
  health_check_grace_period = 300
  target_group_arns         = [var.target_group_arn]
  force_delete              = true

  # Reference the launch template using its latest version.
  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "MultiTier-NodeInstance"
    propagate_at_launch = true
  }
}

# Output the name of the ASG.
output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.app_asg.name
}
