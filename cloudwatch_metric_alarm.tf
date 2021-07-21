provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudwatch_metric_alarm" "alarm_eks_node_mem_utilization" {
  depends_on = [
    aws_sns_topic_subscription.email-target
  ]
  alarm_name          = "EKS-Node-Memory-Utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "node_memory_utilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "75"

  dimensions = {
    ClusterName = var.ClusterName
  }
  tags = {
    Owner       = "alarm_eks_node_mem_utilization for cluster ${var.ClusterName}"
    Terraform   = "true"
  }

  alarm_description = "This metric monitors Your_eks_cluster_name Node Memory Utilization"
  alarm_actions     = [aws_sns_topic.topic.arn]
}

resource "aws_cloudwatch_metric_alarm" "alarm_EKS_Node_CPU_Utilization" {
  depends_on = [
    aws_sns_topic_subscription.email-target
  ]
  alarm_name          = "EKS-Node-CPU-Utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "node_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "80"

  dimensions = {
    ClusterName = var.ClusterName
  }
  tags = {
    Owner       = "alarm_EKS_Node_CPU_Utilization for cluster ${var.ClusterName}"
    Terraform   = "true"
  }

  alarm_description = "This metric monitors Your_eks_cluster_name Node CPU Utilization"
  alarm_actions     = [aws_sns_topic.topic.arn]
}

resource "aws_cloudwatch_metric_alarm" "alarm_EKS_Node_FileSystem_Utilization" {
  depends_on = [
    aws_sns_topic_subscription.email-target
  ]
  alarm_name          = "EKS-Node-FileSystem-Utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "node_filesystem_utilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "80"

  dimensions = {
    ClusterName = var.ClusterName
  }
  tags = {
    Owner       = "alarm_EKS_Node_CPU_Utilization for cluster var.ClusterName"
    Terraform   = "true"
  }

  alarm_description = "This metric monitors Your_eks_cluster_name Node Filesystem Utilization"
  alarm_actions     = [aws_sns_topic.topic.arn]
}





