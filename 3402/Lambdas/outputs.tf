output "sqs_url" {
  value = aws_sqs_queue.purchase_queue.url
}

output "sns_arn" {
  value = aws_sns_topic.email_topic.arn
}

output "lambda_bucket_name" {
  value = aws_s3_bucket.lambda_bucket.bucket
}