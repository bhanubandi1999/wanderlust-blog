provider "aws" {
  region = var.aws_region  # Use the variable for the region
}

# ECR Repository
resource "aws_ecr_repository" "my_repository" {
  name = var.repository_name

  force_delete = true
}

output "repository_url" {
  value = aws_ecr_repository.my_repository.repository_url
}

# Docker image build and push automation using null_resource
resource "null_resource" "build_and_push_docker_image" {
  depends_on = [aws_ecr_repository.my_repository]

  provisioner "local-exec" {
    command = <<EOT
    
      # Login to AWS ECR using AWS CLI
      $(aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.my_repository.repository_url})

      # Build the Docker image
      docker build -t ${var.image_name} -f ./hello-world/Dockerfile .  #Define the path to your Dockerfile

      # Tag the image with the ECR repository URL
      docker tag ${var.image_name}:latest ${aws_ecr_repository.my_repository.repository_url}:${var.image_name}-latest

      # Push the Docker image to the ECR repository
      docker push ${aws_ecr_repository.my_repository.repository_url}:${var.image_name}-latest
    EOT
  }
}

