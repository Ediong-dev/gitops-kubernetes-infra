variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
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