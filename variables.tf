variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-west-2"
}

variable "aws_access_key" {
  description = "The AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "The AWS access key secret"
  type        = string
  sensitive   = true
}

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the Tailscale devices"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key name for the instance"
  type        = string
}

variable "auth_key" {
  description = "Tailscale auth key for device registration"
  type        = string
  sensitive   = true
}
