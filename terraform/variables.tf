#terraform/variables.tf

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = "eu-north-1a"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu 22.04 LTS (valid in eu-north-1)"
  type        = string
  default     = "ami-0339082da191e427e"   # Use this one
}

variable "instance_type" {
  description = "EC2 instance type (free tier eligible)"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the EC2 Key Pair in AWS"
  type        = string
  default     = "portfolio-key"
}

variable "private_key_path" {
  description = "Path to your private key (.pem)"
  type        = string
  default     = "~/.ssh/portfolio-key.pem"
}