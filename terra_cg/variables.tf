variable "naming_prefix" {
  type        = string
  description = "Naming prefix for resources"
  default     = "chaos_genius"
}

variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "ap-south-1"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
}

variable "vpc_subnet_count" {
  type        = number
  description = "Number of subnets to create in VPC"
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
  default     = true
}

variable "instance_type" {
  type        = string
  description = "Type for EC2 Instance"
}

variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "ChaosGenius"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
}