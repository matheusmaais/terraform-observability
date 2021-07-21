resource "aws_sns_topic" "topic" {
  name = "EKS-Notification"
}

resource "aws_sns_topic_subscription" "email-target" {
  depends_on = [
    aws_sns_topic.topic
  ]
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.endpoint
  confirmation_timeout_in_minutes = "10"
}