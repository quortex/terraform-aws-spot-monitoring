/**
 * Copyright 2020 Quortex
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# The fallback autoscaling group autoscaling policy.
resource "aws_autoscaling_policy" "fallback" {
  name                   = var.fallback_asg_policy_name
  scaling_adjustment     = var.fallback_asg_scaling_adjustment
  adjustment_type        = var.fallback_asg_adjustment_type
  policy_type            = "SimpleScaling"
  cooldown               = var.fallback_asg_cooldown
  autoscaling_group_name = var.fallback_asg_name
}

# The cloudwatch metric alarm.
resource "aws_cloudwatch_metric_alarm" "fallback" {
  alarm_name          = var.spot_alarm_name
  alarm_description   = var.spot_alarm_description
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.spot_alarm_evaluation_periods
  datapoints_to_alarm = var.spot_alarm_datapoints_to_alarm
  threshold           = var.spot_alarm_threshold
  alarm_actions       = [aws_autoscaling_policy.fallback.arn]
  metric_query {
    id          = "m1"
    return_data = false

    metric {
      dimensions = {
        "AutoScalingGroupName" = var.spot_asg_name
      }
      metric_name = "GroupDesiredCapacity"
      namespace   = "AWS/AutoScaling"
      period      = 60
      stat        = "Average"
    }
  }
  metric_query {
    id          = "m2"
    return_data = false

    metric {
      dimensions = {
        "AutoScalingGroupName" = var.spot_asg_name
      }
      metric_name = "GroupInServiceCapacity"
      namespace   = "AWS/AutoScaling"
      period      = 60
      stat        = "Average"
    }
  }
  metric_query {
    expression  = "m2/m1*100"
    id          = "e1"
    label       = "Spot Availability"
    return_data = true
  }
}

# The spots autoscaling groups cloudwatch monitoring dashboard.
# This is composed of
# - a widget for viewing the spots autoscaling group GroupDesiredCapacity / GroupInServiceCapacity metrics.
# - an alarm triggered when the percentage of GroupInServiceCapacity relative to GroupInServiceCapacity falls below a given threshold.
resource "aws_cloudwatch_dashboard" "spot_capacity" {
  dashboard_name = var.dashboard_name

  dashboard_body = <<EOF
 {
    "widgets": [
        {
            "type": "metric",
            "x": 0,
            "y": 0,
            "width": 24,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "AWS/AutoScaling", "GroupDesiredCapacity", "AutoScalingGroupName", "${var.spot_asg_name}", { "id": "m2" } ],
                    [ ".", "GroupInServiceCapacity", ".", ".", { "id": "m3" } ],
                    [ ".", "GroupDesiredCapacity", ".", "${var.fallback_asg_name}", { "id": "m5", "yAxis": "left" } ],
                    [ ".", "GroupInServiceCapacity", ".", ".", { "id": "m1" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "period": ${var.dashboard_period},
                "stat": "Average"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 6,
            "width": 12,
            "height": 3,
            "properties": {
                "title": "${var.spot_alarm_name}",
                "annotations": {
                    "alarms": [
                        "${aws_cloudwatch_metric_alarm.fallback.arn}"
                    ]
                },
                "view": "timeSeries",
                "stacked": true
            }
        }
    ]
}
 EOF
}
