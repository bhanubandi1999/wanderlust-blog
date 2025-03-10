variable "aws_region" {
  description = "The AWS region to create resources in"
  default     = "ap-south-1"  # You can modify this to your desired region
}

# Frontend Repository
variable "frontend_repository_name" {
  description = "Name of the frontend Docker ECR repository"
  default     = "frontend-docker-repository"  # You can modify this to your desired repository name
}

# Backend Repository
variable "backend_repository_name" {
  description = "Name of the backend Docker ECR repository"
  default     = "backend-docker-repository"  # You can modify this to your desired repository name
}

# Frontend Image
variable "frontend_image_name" {
  description = "The name of the frontend Docker image"
  default     = "frontend-docker-image"  # You can modify this to your desired image name
}

# Backend Image
variable "backend_image_name" {
  description = "The name of the backend Docker image"
  default     = "backend-docker-image"  # You can modify this to your desired image name
}
