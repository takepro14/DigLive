resource "aws_ssm_parameter" "db_hostname" {
  name        = "DB_HOSTNAME"
  description = ""
  type        = "SecureString"
  value       = var.db_hostname
}

resource "aws_ssm_parameter" "db_username" {
  name        = "DB_USERNAME"
  description = ""
  type        = "SecureString"
  value       = var.db_username
}

resource "aws_ssm_parameter" "access_key_id" {
  name        = "ACCESS_KEY_ID"
  description = ""
  type        = "SecureString"
  value       = var.access_key_id
}

resource "aws_ssm_parameter" "api_url" {
  name        = "API_URL"
  description = ""
  type        = "SecureString"
  value       = var.api_url
}

resource "aws_ssm_parameter" "db_name" {
  name        = "DB_NAME"
  description = ""
  type        = "SecureString"
  value       = var.db_name
}

resource "aws_ssm_parameter" "image_url" {
  name        = "IMAGE_URL"
  description = ""
  type        = "SecureString"
  value       = var.image_url
}

resource "aws_ssm_parameter" "secret_access_key_id" {
  name        = "SECRET_ACCESS_KEY_ID"
  description = ""
  type        = "SecureString"
  value       = var.secret_access_key_id
}

resource "aws_ssm_parameter" "rails_master_key" {
  name        = "RAILS_MASTER_KEY"
  description = ""
  type        = "SecureString"
  value       = var.rails_master_key
}

resource "aws_ssm_parameter" "db_password" {
  name        = "DB_PASSWORD"
  description = ""
  type        = "SecureString"
  value       = var.db_password
}

resource "aws_ssm_parameter" "workdir" {
  name        = "WORKDIR"
  description = ""
  type        = "SecureString"
  value       = var.workdir
}

resource "aws_ssm_parameter" "front_url" {
  name        = "FRONT_URL"
  description = ""
  type        = "SecureString"
  value       = var.front_url
}

