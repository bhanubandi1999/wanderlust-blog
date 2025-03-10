provider "aws" {
  region = var.aws_region  # Use the variable for the region
}

# ECR Repository for Frontend
resource "aws_ecr_repository" "frontend_repository" {
  name = var.frontend_repository_name

  force_delete = true
}

# ECR Repository for Backend
resource "aws_ecr_repository" "backend_repository" {
  name = var.backend_repository_name

  force_delete = true
}

output "frontend_repository_url" {
  value = aws_ecr_repository.frontend_repository.repository_url
}

output "backend_repository_url" {
  value = aws_ecr_repository.backend_repository.repository_url
}

# Docker image build and push automation using null_resource (Frontend)
resource "null_resource" "build_and_push_frontend_docker_image" {
  depends_on = [aws_ecr_repository.frontend_repository]

  provisioner "local-exec" {
    command = <<EOT
    
      # Login to AWS ECR using AWS CLI
      $(aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.frontend_repository.repository_url})

      # Build the Docker image for frontend
      cd ./frontend/
      docker build -t ${var.frontend_image_name} -f Dockerfile .  # Path to your frontend Dockerfile

      # Tag the image with the ECR repository URL for frontend
      docker tag ${var.frontend_image_name}:latest ${aws_ecr_repository.frontend_repository.repository_url}:${var.frontend_image_name}-latest

      # Push the frontend Docker image to the ECR repository
      docker push ${aws_ecr_repository.frontend_repository.repository_url}:${var.frontend_image_name}-latest
    EOT
  }
}

# Docker image build and push automation using null_resource (Backend)
resource "null_resource" "build_and_push_backend_docker_image" {
  depends_on = [aws_ecr_repository.backend_repository]

  provisioner "local-exec" {
    command = <<EOT
    
      # Login to AWS ECR using AWS CLI
      $(aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.backend_repository.repository_url})

      # Build the Docker image for backend
      cd  ./backend/
      docker build -t ${var.backend_image_name} -f Dockerfile .  # Path to your backend Dockerfile

      # Tag the image with the ECR repository URL for backend
      docker tag ${var.backend_image_name}:latest ${aws_ecr_repository.backend_repository.repository_url}:${var.backend_image_name}-latest

      # Push the backend Docker image to the ECR repository
      docker push ${aws_ecr_repository.backend_repository.repository_url}:${var.backend_image_name}-latest
    EOT
  }
}
