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

variable "region" {
  type        = string
  description = "The region in which to create resources."
}

variable "spot_asg_name" {
  type        = string
  description = "The Spots dedicated autoscaling group name."
}

variable "fallback_asg_name" {
  type        = string
  description = "The backup autoscaling group in the event of non-provisioning of spot instances."
}

variable "dashboard_name" {
  type        = string
  description = "The name of the cloudwatch dashboard."
  default     = "spots-capacity"
}

variable "dashboard_period" {
  type        = number
  description = "The cloudwatch dashboard refresh interval inseconds."
  default     = 60
}

variable "fallback_asg_policy_name" {
  type        = string
  description = "The name of the fallback autoscaling group scaling policy."
  default     = "fallback"
}

variable "fallback_asg_adjustment_type" {
  type        = string
  description = "Specifies whether the adjustment is an absolute number or a percentage of the current capacity. Valid values are ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity."
  default     = "ChangeInCapacity"
}

variable "fallback_asg_scaling_adjustment" {
  type        = number
  description = "The number of instances by which to scale. fallback_asg_adjustment_type determines the interpretation of this number (e.g., as an absolute number or as a percentage of the existing Auto Scaling group size). A positive increment adds to the current capacity and a negative value removes from the current capacity."
  default     = 2
}

variable "fallback_asg_cooldown" {
  type        = number
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
  default     = 60
}

variable "spot_alarm_name" {
  type        = string
  description = "The descriptive name for the alarm. This name must be unique within the user's AWS account."
  default     = "Spot alarm"
}

variable "spot_alarm_description" {
  type        = string
  description = "The description for the alarm."
  default     = "An alarm when no spot instances are schedulable."
}

variable "spot_alarm_threshold" {
  type        = number
  description = "The threshold below which the alarm is triggered."
  default     = 90
}

variable "spot_alarm_evaluation_periods" {
  type        = number
  description = "The number of periods over which data is compared to the specified threshold."
  default     = 2
}

variable "spot_alarm_datapoints_to_alarm" {
  type        = number
  description = "The number of datapoints that must be breaching to trigger the alarm."
  default     = 2
}
