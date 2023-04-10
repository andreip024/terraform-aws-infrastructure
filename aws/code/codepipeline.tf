resource "aws_codepipeline" "deployment_pipeline" {
  name     = "${local.project_name}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn
  depends_on    = [aws_iam_role.codepipeline_role]

   artifact_store {
     location = aws_s3_bucket.codepipeline_bucket.bucket
     type     = "S3"

    # encryption_key {
    #   id   = data.aws_kms_alias.s3kmskey.arn
    #   type = "KMS"
    # }
  }

  stage {
    name      = "Source"

    action {
      name              = "SourceAction"
      category          = "Source"
      owner             = "ThirdParty"
      provider          = "GitHub"
      version           = "1"
      output_artifacts  = ["source_output"]

      configuration = {
        Owner       = local.ci_project_user
        Repo        = local.ci_project_name
        Branch      = "main"
        OAuthToken  = var.github_oauth_token
      }
    }
  }
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.code_build.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ClusterName = data.terraform_remote_state.ecs.outputs.ClusterName
        ServiceName = data.terraform_remote_state.ecs.outputs.ServiceName
      }
    }
  }
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = local.pipeline_buket
  force_destroy = true
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}