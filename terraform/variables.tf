variable "project_name" {
}

variable "registry_name_base" {
}

variable "registry_name_custom" {
}

variable "env" {
}

variable "smce_aws_account_id" {
  type        = string
  sensitive   = true
}

variable "smce_aws_access_key" {
  type        = string
  sensitive   = true
}

variable "smce_aws_secret_key" {
  type        = string
  sensitive   = true
}

variable "smce_aws_session_token" {
  type        = string
  sensitive   = true
}

variable "tags" {
  type        = map
  default     = {}
  description = "Optional tags to add to resources"
}
