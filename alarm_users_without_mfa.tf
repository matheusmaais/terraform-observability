
#this file will create a cloud trail and send logs to s3 bucket
#create a log group on cloudwatch linked to created bucket and   specific metric that trigger a alarm when some user log in your aws account without use MFA
#to query wich user made login:
#go to your log group -> log_stream and query for:
#{$.eventName = ConsoleLogin && $.additionalEventData.MFAUsed = No}






resource "aws_iam_role" "cloudtrail_role" {
  name = "cloudtrail-to-cloudwatch"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudtrail_example" {
  name = "cloudtrail-example"
  role = aws_iam_role.cloudtrail_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailCreateLogStream",
      "Effect": "Allow",
      "Action": ["*"],
      "Resource": [
        "*"
      ]
    },
    {
      "Sid": "AWSCloudTrailPutLogEvents",
      "Effect": "Allow",
      "Action": ["*"],
      "Resource": [
        "*"
        ] 
    }
  ]
}
EOF
}
# -----------------------------------------------------------
# set up logging bucket
# -----------------------------------------------------------

resource "aws_s3_bucket" "log_bucket" {
  bucket_prefix = "cloudtrail-logs-${var.env}"
  acl           = "private"
  #region        = var.region

  versioning {
    enabled = false
  }
  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = aws_s3_bucket.log_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow bucket ACL check",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "cloudtrail.amazonaws.com",
          "logs.${var.region}.amazonaws.com",
          "lambda.amazonaws.com"
          ]
        },
      "Action": "s3:GetBucketAcl",
      "Resource": "${aws_s3_bucket.log_bucket.arn}"
    },
    {
      "Sid": "Allow bucket write",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "cloudtrail.amazonaws.com",
          "logs.${var.region}.amazonaws.com"
        ]
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.log_bucket.arn}/*",
      "Condition": {"StringEquals": {"s3:x-amz-acl": "bucket-owner-full-control"}}
    },
    {
      "Sid": "Allow bucket write for lambda",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.log_bucket.arn}/*"
    }
  ]
}
POLICY
}


# -----------------------------------------------------------
# setup cloudwatch logs to receive cloudtrail events
# -----------------------------------------------------------

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name = "cloudtrail"
  retention_in_days = 5
  tags              = "${merge(map("Name", "Cloudtrail"))}"
}

# -----------------------------------------------------------
# turn cloudtrail on for this region
# -----------------------------------------------------------

resource "aws_cloudtrail" "example" {
  name                          = "CloudTrail-${var.env}"
  depends_on = [
      aws_cloudwatch_log_group.cloudtrail
  ]
  s3_bucket_name                = aws_s3_bucket.log_bucket.id
  s3_key_prefix                 = "cloudtrail-logs-${var.env}"
  include_global_service_events = true
  enable_logging                = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_role.arn

  advanced_event_selector {
  //TODO try to log only ConsoleLogin events
    # field_selector {
    #   field  = "eventName"
    #   starts_with = ["ConsoleLogin"]
    # }
    field_selector {
      field = "eventCategory"
      equals = ["Management"]
    }
  }
  
}

# ----------------------
# watch for use of the console without MFA
# ----------------------
resource "aws_cloudwatch_log_metric_filter" "console_without_mfa" {
  name           = "console-without-mfa"
  pattern        = "{$.eventName = ConsoleLogin && $.additionalEventData.MFAUsed = No}"
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name

  metric_transformation {
    name      = "ConsoleWithoutMFACount"
    namespace = "CloudTrail"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "console_without_mfa" {
  alarm_name          = "login-without-mfa-${var.project}-${var.env}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ConsoleWithoutMFACount"
  namespace           = "CloudTrail"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Use of the console by an account without MFA has been detected"
  alarm_actions       = [aws_sns_topic.topic.arn]
}