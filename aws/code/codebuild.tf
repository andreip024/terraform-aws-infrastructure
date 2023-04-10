resource "aws_codebuild_source_credential" "code_build_credentials" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.github_oauth_token
}
resource "aws_codebuild_project" "code_build" {
  name          = "${local.project_name}-CB-project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role.arn
  depends_on    = [aws_iam_role.codebuild_role]

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${local.project_name}-CW"
    }
  }

  source {
    type            = "GITHUB" 
    location        = local.ci_project_url
    git_clone_depth = 1
    buildspec       = file("../../templates/buildspec.yml")

    git_submodules_config {
      fetch_submodules = true
    }
    auth {
      type     = "OAUTH"
      resource = aws_codebuild_source_credential.code_build_credentials.arn
    }
  }
    
  source_version = "main"
}
