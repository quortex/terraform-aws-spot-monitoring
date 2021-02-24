[![Quortex][logo]](https://quortex.io)
# terraform-aws-spot-monitoring
A terraform module for Quortex infrastructure AWS spot instances monitoring.

It provides a set of resources necessary to provision monitoring of an autoscaling group spot instances and backup strategies on a fallback on demand autoscaling group.
A scale-out of the fallback group is triggered when the specified Spot group's "InServiceCapacity" metric falls below 90% of the "DesiredCapacity" for a duration of 2x60s. The threshold and duration values are configurable.

This module is available on [Terraform Registry][registry_tf_aws_spot_monitoring].

Get all our terraform modules on [Terraform Registry][registry_tf_modules] or on [Github][github_tf_modules] !

## Created resources

This module creates the following resources on AWS:

- a SimpleScaling autoscaling policy on given fallback autoscaling group
- a cloudwatch dashboard with a widget for spots / fallback capacity monitoring
- a cloudwatch alarm to scale up fallback autoscaling group on spots lacks of capacity

![dashboard]

## Usage example

```hcl
module "aks-cluster" {
  source = "quortex/spot-monitoring/aws"

  # Globally used variables.
  region            = var.region
  spot_asg_name     = "my-spot-autoscaling-group"
  fallback_asg_name = "my-fallback-autoscaling-group"
}
```

## Help

**Got a question?**

File a GitHub [issue](https://github.com/quortex/terraform-aws-spot-monitoring/issues) or send us an [email][email].


  [logo]: https://storage.googleapis.com/quortex-assets/logo.webp
  [email]: mailto:info@quortex.io
  [registry_tf_modules]: https://registry.terraform.io/modules/quortex
  [registry_tf_aws_spot_monitoring]: https://registry.terraform.io/modules/quortex/spot-monitoring/aws
  [github_tf_modules]: https://github.com/quortex?q=terraform-
  [dashboard]: https://storage.googleapis.com/quortex-assets/aws_spot_monitoring_dashboard.jpg
