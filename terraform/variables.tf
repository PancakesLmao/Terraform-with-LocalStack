variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "repo_url" {
  description = "The repository URL to clone"
  type        = string
}

variable "branch" {
  description = "The branch to checkout"
  type        = string
}