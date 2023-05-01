variable "project_name" {
}

variable "registry_name_base" {
}

variable "registry_name_custom" {
}

variable "env" {
}

variable "tags" {
  type        = map
  default     = {}
  description = "Optional tags to add to resources"
}
