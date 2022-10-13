variable "tag_course" {
  type    = string
  default = "clcm-3402"
}

variable "tag_created_by" {
  type    = string
  default = "terraform"
}

variable "email_topic_name" {
  type = string
}

variable "emails" {
  type = list(any)
}

variable "purchase_queue_name" {
  type = string
}

variable "email_queue_name" {
  type = string
}

variable "database_queue_name" {
  type = string
}

variable "fanout_topic_name" {
  type = string
}

variable "purchase_table_name" {
  type = string
}