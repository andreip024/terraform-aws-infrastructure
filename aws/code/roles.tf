resource "aws_iam_policy" "codebuild_policy" {
  name        = "${local.project_name}-CodBuild-Policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CodBuildPolicy",
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents",
              "codebuild:StartBuild",
              "codebuild:CreateProject",
              "s3:PutObject",
              "s3:GetObject",
              "s3:GetObjectVersion",
              "s3:GetBucketAcl",
              "s3:GetBucketLocation",
              "ecr:*"
            ],
            "Resource": "*"
          }
    ]
}
EOF
}

resource "aws_iam_role" "codebuild_role" {
  name               = "${local.project_name}-CodBuild-Role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  policy_arn = aws_iam_policy.codebuild_policy.arn
  role       = aws_iam_role.codebuild_role.name
}

resource "aws_iam_policy" "codepipeline_policy" {
  name        = "${local.project_name}-CodPipeline-Policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CodPipelinePolicy",
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
          }
    ]
}
EOF
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "${local.project_name}-CodePipeline-Role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_policy_attachment" {
  policy_arn = aws_iam_policy.codepipeline_policy.arn
  role       = aws_iam_role.codepipeline_role.name
}

###