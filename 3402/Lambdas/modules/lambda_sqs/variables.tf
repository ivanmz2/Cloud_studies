variable "s3_bucket" {
  type = string
}

variable "s3_key" {
  type = string
}

variable "function_name" {
  type = string
}

variable "sqs_arn" {
  type = string
}

variable "handler" {
  type    = string
  default = "main.handler"
}