output "function_name" {
  value = aws_lambda_function.lambda_func.function_name
}

output "function_role_name" {
  value = aws_iam_role.iam_for_lambda.name
}