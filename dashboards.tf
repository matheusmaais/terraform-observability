resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "dashboard-${var.env}"



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
                    "metrics": 
                    [
                     [{"expression":"SEARCH('{AWS/AutoScaling,AutoScalingGroupName}', 'Average', 300)"}]
                    ],
                    "title": "AutoScaling Informations",
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
                    "metrics": 
                    [
                        [{"expression":"SEARCH('{ContainerInsights,ClusterName,InstanceId,NodeName} ClusterName=\"your_cluster_name\" InstanceId node_memory_utilization', 'Maximum', 300)"}]
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
                    "metrics": 
                    [ 
                      [{"expression":"SEARCH('{ContainerInsights,ClusterName,InstanceId,NodeName} ClusterName=\"your_cluster_name\" InstanceId node_cpu_utilization', 'Maximum', 300)"}]
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
                    "metrics": 
                    [
                          [{"expression":"SEARCH('{ContainerInsights,ClusterName,InstanceId,NodeName} ClusterName=\"your_cluster_name\" InstanceId node_filesystem_utilization', 'Maximum', 300)"}]   
                    ],
                    "title": "EKS Nodes FileSystem % Utilization",
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
                    "metrics": 
                    [
                          [{"expression":"SEARCH('{ContainerInsights,ClusterName,InstanceId,NodeName} ClusterName=\"your_cluster_name\" InstanceId node_network_total_bytes', 'Maximum', 300)"}]   
                    ],
                    "title": "EKS Nodes Networking",
                    "stat":"Average",
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
                    "metrics":
                    [
                          [{"expression":"SEARCH('{ContainerInsights,ClusterName,InstanceId,NodeName} ClusterName=\"your_cluster_name\" InstanceId number_of_running_pods', 'Maximum', 300)"}]   
                    ],
                    "title": "EKS Running Pods",
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


 

