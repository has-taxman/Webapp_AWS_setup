#########################################################
# Launch Template and Auto Scaling Group for Node.js
#########################################################

# Get the latest Amazon Linux 2 AMI.
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.7.20250512.0-kernel-6.1-x86_64"]
  }
}

# Launch Template for the Node.js app instances.
resource "aws_launch_template" "app_lt" {
  name_prefix            = "multi-tier-lt-"
  image_id               = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.instance_sg_id] # Updated argument

  # User data must be provided as a base64-encoded string.
  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -euxo pipefail
    exec > >(tee /var/log/user-data.log) 2>&1

    echo "Starting user-data at $(date)"

    # 1) Update OS and install Git & Node.js
    if command -v dnf &>/dev/null; then
      # Amazon Linux 2023
      dnf update -y
      dnf install -y git nodejs
    else
      # Amazon Linux 2
      yum update -y
      yum install -y git
      # Install Node.js 14.x from NodeSource
      curl -fsSL https://rpm.nodesource.com/setup_14.x | bash -
      yum install -y nodejs
    fi

    # 2) Clone and start the app
    git clone https://github.com/has-taxman/Webapp_AWS_setup.git /home/ec2-user/app
    cd /home/ec2-user/app/my-node-app

    npm install --production
    nohup node index.js > /var/log/app.log 2>&1 &

    echo "User-data complete at $(date)"
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
