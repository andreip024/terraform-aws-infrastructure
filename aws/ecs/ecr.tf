resource "aws_ecr_repository" "ecs_registry" {
  name                 = lower("${local.project_name}")
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push       = true
  }

}

resource "aws_ecr_lifecycle_policy" "ecs_registry_lifecycle_policy" {
  repository = aws_ecr_repository.ecs_registry.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 10 images"
      action       = {
        type = "expire"
      }
      selection     = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}