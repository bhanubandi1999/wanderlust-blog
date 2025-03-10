variable "aws_region" {
  description = "The AWS region to create resources in"
  default     = "ap-south-1"  # You can modify this to your desired region
}

variable "repository_name" {
  description = "Name of the Docker ECR repository"
  default     = "team-docker-repository"
}

variable "image_name" {
  description = "The name of the Docker image"
  default     = "team-docker-image"  # You can modify this to your desired image name
}
