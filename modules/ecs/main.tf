resource "aws_ecs_cluster" "app_cluster" {
  name = "app-cluster"
}

resource "aws_launch_configuration" "app_config" {
  name = "app-config"
  image_id = "ami-0c55b159cbfafe1f0" # Update this with the latest AMI
  instance_type = "t2.micro"
  security_groups = [aws_security_group.app_sg.id]
  user_data = <<-EOT
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y docker
              sudo docker run -d -p 80:80 my-web-app-image
              EOT
  lifecycle {
    create_before_destroy = true
  }
}
