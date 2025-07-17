resource "aws_launch_template" "web_template" {
  name_prefix   = "web-launch-template"
  image_id      = "ami-0150ccaf51ab55a51"
  instance_type = "t2.micro"
  key_name      = "keys"  # Change this to your actual key pair name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_sg.id]
  }

  user_data = base64encode(<<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd aws-cli
                systemctl start httpd
                systemctl enable httpd
                
                # Sync from your S3 bucket
                aws s3 sync s3://dragon-project-cloud-2030 /var/www/html --region us-east-1

                # Make sure index.html points to your actual file
                if [ -f /var/www/html/dragon.html ]; then
                  rm -f /var/www/html/index.html
                  cp /var/www/html/dragon.html /var/www/html/index.html
                fi
                EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "AutoScaledWebServer"
    }
  }

  monitoring {
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
