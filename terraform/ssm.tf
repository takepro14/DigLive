resource "aws_ssm_parameter" "db_username" {
  name        = "DB_USERNAME"
  description = ""
  type        = "SecureString"
  value       = var.db_username
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

resource "aws_ssm_parameter" "front_port" {
  name        = "FRONT_PORT"
  description = ""
  type        = "SecureString"
  value       = var.front_port
}

resource "aws_ssm_parameter" "api_domain" {
  name        = "API_DOMAIN"
  description = ""
  type        = "SecureString"
  value       = var.api_domain
}

resource "aws_ssm_parameter" "base_url" {
  name        = "BASE_URL"
  description = ""
  type        = "SecureString"
  value       = var.base_url
}

resource "aws_ssm_parameter" "api_port" {
  name        = "API_PORT"
  description = ""
  type        = "SecureString"
  value       = var.api_port
}

resource "aws_ssm_parameter" "rails_master_key" {
  name        = "RAILS_MASTER_KEY"
  description = ""
  type        = "SecureString"
  value       = var.rails_master_key
}

resource "aws_ssm_parameter" "container_port" {
  name        = "CONTAINER_PORT"
  description = ""
  type        = "SecureString"
  value       = var.container_port
}

resource "aws_ssm_parameter" "db_name" {
  name        = "DB_NAME"
  description = ""
  type        = "SecureString"
  value       = var.db_name
}

resource "aws_ssm_parameter" "db_hostname" {
  name        = "DB_HOSTNAME"
  description = ""
  type        = "SecureString"
  value       = var.db_hostname
}

resource "aws_ssm_parameter" "api_url" {
  name        = "API_URL"
  description = ""
  type        = "SecureString"
  value       = var.api_url
}

