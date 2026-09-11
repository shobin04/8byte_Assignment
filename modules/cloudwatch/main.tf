resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "cpu-utilization-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300  # 5 minutes
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm triggers when CPU utilization is 80% or higher"
  alarm_actions       = [var.alarm_action_arn]
  ok_actions          = [var.ok_action_arn]
  dimensions = {
    InstanceId = var.instance_id
  }
  
}
