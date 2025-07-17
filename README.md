# 🐾 Moewish: Auto-Scaling Web App on AWS with Terraform

Moewish is an AWS-based infrastructure-as-code project that deploys a scalable, load-balanced web application showing an adorable album of kittens. Built and managed with Terraform, it supports auto-scaling, CloudWatch monitoring, and automatic recovery.

> 👥 **Contributors:** Ok Serey, Soth Vandy, Tun Monireaksa, Phum Pidun, So Bunna

---

## 📁 Project Structure

| File                 | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `provider.tf`        | Configures the AWS provider and region (`us-east-1`).                  |
| `vpc.tf`             | Creates the custom VPC, subnets, route tables, and Internet Gateway.        |
| `security.tf`        | Defines security groups for EC2 and load balancer.                          |
| `iam.tf`             | Provides an IAM role/profile to allow EC2 instances to access S3.           |
| `s3.tf`              | Defines the S3 bucket to host static web content.                           |
| `launch_template.tf` | EC2 launch template including `user_data` to bootstrap Apache and sync S3. |
| `asg.tf`             | Auto Scaling Group that uses the launch template and spans two subnets.     |
| `elb.tf`             | Application Load Balancer and target group with health check config.        |
| `cloudwatch.tf`      | Defines CloudWatch alarms for monitoring CPU usage and instance health.     |
| `output.tf`          | Outputs important values like ALB DNS and ASG name.                         |

---
## 🚀 Terraform Configuration

**Step-by-step Deployment**

1. Initialize Terraform:
```terraform init```

2. Check the execution plan:
```terraform plan```

3. Apply infrastructure:
```terraform apply```

4. Clean up all resources:
```terraform destroy```
---
## 🔍 Verifying the Deployment

**View Public DNS to access the app**
```http://web-alb-516352784.us-east-1.elb.amazonaws.com```

**Check Public IPs of EC2 Instances**
```aws ec2 describe-instances --filters Name=tag:Name,Values=WebServerInASG --query "Reservations[*].Instances[*].PublicIpAddress" --output table```

**Check CloudWatch Alarm Status**
```aws cloudwatch describe-alarms --query "MetricAlarms[?contains(AlarmName, 'ASG')].[AlarmName,StateValue]" --output table```

**List All EC2 Instances in ASG**
```aws ec2 describe-instances --filters Name=tag:Name,Values=WebServerInASG --query "Reservations[*].Instances[*].[InstanceId,State.Name]" --output table```

**View Auto Scaling Group and Desired Capacity**
```aws autoscaling describe-auto-scaling-groups --query "AutoScalingGroups[*].[AutoScalingGroupName,DesiredCapacity]" --output table```






---
## 📦 EC2 Bootstrapping Script (`user_data`)

This script is embedded in `launch_template.tf` and runs on each EC2 instance to install the web server and sync content:

```bash
#!/bin/bash
yum update -y
yum install -y httpd aws-cli
systemctl start httpd
systemctl enable httpd
aws s3 sync s3://dragon-project-cloud-2030 /var/www/html --region us-east-1
if [ -f /var/www/html/dragon.html ]; then
    rm -f /var/www/html/index.html
    cp /var/www/html/dragon.html /var/www/html/index.html