resource "aws_cloudwatch_metric_alarm" "cpu_high_alarm" {
  alarm_name          = "HighCPUAlarm-ASG"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm triggers when CPU is above 80%"
  alarm_actions       = []
}

resource "aws_cloudwatch_metric_alarm" "status_check_failed_alarm" {
  alarm_name          = "StatusCheckFailed-ASG"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "This alarm triggers when instance fails health check"
  alarm_actions       = []
}

