# terraform-observability

This terraform files will create:
* EKS Container insights Dashboards
* Metrics for EKS-Nodes, cpu, mem, and filesystem % utilization
* Alarms for EKS-Nodes cpu, mem, and filesystem % utilization (SNS topic and subscription), AWS will send you a  email reporting the alarm

It's only exemple implementation, you could transform it in a module or just add this files on your terraform directory.

USAGE:

1 - Enable Container insights:
log in on your eks cluster and run:
  Set envs:
  EKS_CLUSTER_NAME="your_cluster_name" ex: 
  EKS_CLUSTER_REGION="your_region" ex: "us-east-1"

  $curl -O https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluentd-quickstart.yaml
  
  $sed -ie "s/{{cluster_name}}/${EKS_CLUSTER_NAME}/;s/{{region_name}}/${EKS_CLUSTER_REGION}/" cwagent-fluentd-quickstart.yaml
  
  $kubectl apply -f ./cwagent-fluentd-quickstart.yaml
  
  Will be created for each node 2 pods ( cloudwatch agent and fluentd-cloudwatch, and 2 demonsets)

  $kubectl get all -n amazon-cloudwatch
  
  Documentation
  https://computingforgeeks.com/install-cloudwatch-container-insights-on-eks/

2 - Change 
 * on dashboards.tf for your values every ocurrency of
   
   Your_autoScaling_group_name
   Your_eks_cluster_name
   
   tip: get eks-cluster name:  
     $aws eks list-clusters
   tip2: to get autoScaling Group Name:
       $aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[?contains(Tags[?Key==`eks:cluster-name`].Value, `your_cluster_name`)].[AutoScalingGroupName]'
   

*  fill on terraform.tfvars 

3 - Run terraform commands:
    $terraform init
    $terraform plan -out tfplan
    $terraform apply tfplan


Documentation
  https://computingforgeeks.com/install-cloudwatch-container-insights-on-eks/
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription
  https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html
  https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create_dashboard.html
  https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-cloudwatch-dashboard.html