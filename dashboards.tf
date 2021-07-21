resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "dashboard-example"

  dashboard_body = <<EOF
  {
        "widgets": [
            {
                "type": "metric",
                "x": 0,
                "y": 0,
                "width": 12,
                "height": 6,
                "properties": {
                    "metrics": [
                        [
                            "AWS/EC2",
                            "CPUUtilization",
                            "AutoScalingGroupName",
                            "YourAutoScalingGroupName"
                        ]
                    ],
                    "title": "AutoScaling CPU",
                    "stat":"Maximum",
                    "region":"us-east-1",
                    "view": "timeSeries",
                    "stacked": false,
                    "period": 300
                }
            },
            {
                "type": "metric",
                "x": 0,
                "y": 0,
                "width": 12,
                "height": 6,
                "properties": {
                    "metrics": [
                        [
                            "AWS/EC2",
                            "NetworkIn",
                            "AutoScalingGroupName",
                            "Your_autoScaling_group_name"
                        ],
                        [
                            "AWS/EC2",
                            "NetworkOut",
                            "AutoScalingGroupName",
                            "Your_autoScaling_group_name"   
                        ]
                    ],
                    "title":"Network In/Out",
                    "stat":"Average",
                    "region":"us-east-1",
                    "view":"timeSeries",
                    "stacked": false,
                    "period": 300
                }
            },
            {
                "type": "metric",
                "x": 0,
                "y": 0,
                "width": 12,
                "height": 6,
                "properties": {
                    "metrics": [
                        [
                            "AWS/EC2",
                            "NetworkPacketsIn",
                            "AutoScalingGroupName",
                            "Your_autoScaling_group_name"
                        ],
                        [
                            "AWS/EC2",
                            "NetworkPacketsOut",
                            "AutoScalingGroupName",
                            "Your_autoScaling_group_name"   
                        ]
                    ],
                    "title":"Network Packets In/Out",
                    "stat":"Average",
                    "region":"us-east-1",
                    "view":"timeSeries",
                    "stacked": false,
                    "period": 300
                }

            },
            {
                "type": "metric",
                "x": 0,
                "y": 0,
                "width": 12,
                "height": 6,
                "properties": {
                    "metrics": [
                        [
                            "AWS/EC2",
                            "StatusCheckFailed",
                            "AutoScalingGroupName",
                            "Your_autoScaling_group_name"
                        ],
                        [
                            "AWS/EC2",
                            "StatusCheckFailed_Instance",
                            "AutoScalingGroupName",
                            "Your_autoScaling_group_name"   
                        ],
                        [
                            "AWS/EC2",
                            "StatusCheckFailed_System",
                            "AutoScalingGroupName",
                            "Your_autoScaling_group_name"   
                        ]
                    ],
                    "title":"Status Check",
                    "stat":"Average",
                    "region":"us-east-1",
                    "view":"timeSeries",
                    "stacked": false,
                    "period": 300
                }
            },
            {
                "type": "metric",
                "x": 0,
                "y": 0,
                "width": 12,
                "height": 6,
                "properties": {
                    "metrics": [
                        [
                            "ContainerInsights",
                            "node_memory_utilization",
                            "ClusterName",
                            "Your_eks_cluster_name"
                        ]
                    ],
                    "title": "EKS Nodes Memory % Utilization",
                    "stat":"Maximum",
                    "region":"us-east-1",
                    "view": "timeSeries",
                    "stacked": false,
                    "period": 300
                }
            },
            {   
                "type": "metric",
                "x": 0,
                "y": 0,
                "width": 12,
                "height": 6,
                "properties": {
                    "metrics": [
                        [
                            "ContainerInsights",
                            "node_cpu_utilization",
                            "ClusterName",
                            "Your_eks_cluster_name"
                        ]
                    ],
                    "title": "EKS Nodes CPU % Utilization",
                    "stat":"Maximum",
                    "region":"us-east-1",
                    "view": "timeSeries",
                    "stacked": false,
                    "period": 300
                }
            },
            {
                "type": "metric",
                "x": 0,
                "y": 0,
                "width": 12,
                "height": 6,
                "properties": {
                    "metrics": [
                        [
                            "ContainerInsights",
                            "node_filesystem_utilization",
                            "ClusterName",
                            "Your_eks_cluster_name"
                        ]
                    ],
                    "title": "EKS Nodes FileSystem % Utilization",
                    "stat":"Maximum",
                    "region":"us-east-1",
                    "view": "timeSeries",
                    "stacked": false,
                    "period": 300
                }
            }
        ]
    }
EOF
}


 

