variable "provider_url" {
  description = "Iam OpenID Connect Provider URL"
  type = string
}

variable "provider_arn" {
  description = "Iam OpenID Connect Provider ARN"
  type = string
}

variable "k8s_namespace" {
  description = "Service account namespace"
  type = string
}

variable "k8s_serviceaccount" {
  description = "Service account name"
  type = string
}

variable "policy_json" {
  description = "IAM Role policy"
  type = string
  default = "none"
}

variable "policy_arn" {
  description = "IAM Role policy ARN"
  type = string
  default = "none"
}