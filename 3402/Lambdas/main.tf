# create purchase queue
resource "aws_sqs_queue" "purchase_queue" {
  name = var.purchase_queue_name

  tags = {
    "course"     = var.tag_course
    "created_by" = var.tag_created_by
  }
}

# create SNS topic to send emails to customers
resource "aws_sns_topic" "email_topic" {
  name         = var.email_topic_name
  display_name = "My Awesome Company"

  tags = {
    "course"     = var.tag_course
    "created_by" = var.tag_created_by
  }
}

# the topic that sends a message to both database and email queues
resource "aws_sns_topic" "fanout_topic" {
  name = var.fanout_topic_name

  tags = {
    "course"     = var.tag_course
    "created_by" = var.tag_created_by
  }
}

# create subscriptions for any email present in the `emails` variable
resource "aws_sns_topic_subscription" "email_subscription" {
  for_each  = toset(var.emails)
  endpoint  = each.key
  protocol  = "email"
  topic_arn = aws_sns_topic.email_topic.arn
}

# create an SQS subscription for the database queue
resource "aws_sns_topic_subscription" "database_subscription" {
  endpoint  = aws_sqs_queue.database_queue.arn
  protocol  = "sqs"
  topic_arn = aws_sns_topic.fanout_topic.arn
}

# create an SQS subscription for the notification (email) queue
resource "aws_sns_topic_subscription" "notification_subscription" {
  endpoint  = aws_sqs_queue.email_queue.arn
  protocol  = "sqs"
  topic_arn = aws_sns_topic.fanout_topic.arn
}

# allowing the fanout SNS topic to publish messages to the database queue
resource "aws_sqs_queue_policy" "database_allow_fanout" {
  queue_url = aws_sqs_queue.database_queue.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.database_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.fanout_topic.arn}"
        }
      }
    }
  ]
}
POLICY
}

# allowing the fanout SNS topic to publish messages to the notification (email) queue
resource "aws_sqs_queue_policy" "notification_allow_fanout" {
  queue_url = aws_sqs_queue.email_queue.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.email_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.fanout_topic.arn}"
        }
      }
    }
  ]
}
POLICY
}

# create a dynamodb table with `id` as the hash (main, primary) key
resource "aws_dynamodb_table" "purchase_table" {
  name           = var.purchase_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

# create notification (email) queue
resource "aws_sqs_queue" "email_queue" {
  name = var.email_queue_name

  tags = {
    "course"     = var.tag_course
    "created_by" = var.tag_created_by
  }
}

# create database queue
resource "aws_sqs_queue" "database_queue" {
  name = var.database_queue_name

  tags = {
    "course"     = var.tag_course
    "created_by" = var.tag_created_by
  }
}

# create S3 bucket for Lambda code
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "lambda-code-37847384378-ivan"
}

# create Lambda function using the lambda_sqs module
module "purchase_lambda" {
  source        = "./modules/lambda_sqs"
  function_name = "purchase"
  s3_bucket     = aws_s3_bucket.lambda_bucket.bucket
  s3_key        = "purchase/artifact.zip"
  sqs_arn       = aws_sqs_queue.purchase_queue.arn

  depends_on = [
    aws_sqs_queue.purchase_queue
  ]
}

# add a policy to the function role so it can publish to SNS
resource "aws_iam_policy" "lambda_publish_sns" {
  name        = "lambda_publish_sns"
  description = "IAM policy for sending SNS messages"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sns:Publish"
       ],
      "Resource": "${aws_sns_topic.fanout_topic.arn}"
    }
  ]
}
EOF
}

# attach the policy to the function role
resource "aws_iam_role_policy_attachment" "lambda_publish_sns" {
  role       = module.purchase_lambda.function_role_name
  policy_arn = aws_iam_policy.lambda_publish_sns.arn

  depends_on = [
    module.purchase_lambda
  ]
}