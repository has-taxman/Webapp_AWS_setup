#########################################################
# CloudWatch Alarms for EC2 Instances in the ASG
#########################################################

# CPU High Alarm - triggers if CPU utilization is above 80%.
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when CPU utilization is too high"
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

# CPU Low Alarm - triggers if CPU utilization is below 20%.
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "low-cpu-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "Alarm when CPU utilization is too low"
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}
