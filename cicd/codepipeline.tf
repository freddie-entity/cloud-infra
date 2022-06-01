resource "aws_codepipeline" "project_app_pipeline" {
  name     = "project-app-pipeline"
  role_arn = aws_iam_role.apps_codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.cicd_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      configuration = {
        "BranchName" = var.project_repository_branch
        # "PollForSourceChanges" = "false"
        "RepositoryName" = var.project_repository_name
      }
      input_artifacts = []
      name            = "Source"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeCommit"
      run_order = 1
      version   = "1"
    }
  }
  stage {
    name = "Build"

    action {
      category = "Build"
      configuration = {
        "EnvironmentVariables" = jsonencode(
          [
            {
              name = "environment"
              type = "PLAINTEXT"
              #   value = var.env
              value = "dev"
            },
            {
              name = "AWS_DEFAULT_REGION"
              type = "PLAINTEXT"
              #   value = var.aws_region
              value = "ap-southeast-1"
            },
            {
              name = "AWS_ACCOUNT_ID"
              #   type  = "PARAMETER_STORE"
              type = "PLAINTEXT"
              #   value = var.account_id
              value = "158904540988"
            },
            {
              name = "IMAGE_REPO_NAME"
              type = "PLAINTEXT"
              value = var.ecr_name
            #   value = "freddieentity"
            },
            {
              name  = "IMAGE_TAG"
              type  = "PLAINTEXT"
              value = "latest"
            },
            {
              name  = "ECS_CONTAINER_NAME"
              type  = "PLAINTEXT"
              value = var.aws_ecs_container_name
            },
          ]
        )
        "ProjectName" = aws_codebuild_project.containerAppBuild.name
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name = "Build"
      output_artifacts = [
        "BuildArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
    }
  }
  stage {
    name = "Deploy"

    action {
      category = "Deploy"
      configuration = {
        "ClusterName" = var.aws_ecs_cluster_name
        "ServiceName" = var.aws_ecs_python_app_service_name
        "FileName"    = "imagedefinitions.json"
        #"DeploymentTimeout" = "15"
      }
      input_artifacts = [
        "BuildArtifact",
      ]
      name             = "Deploy"
      output_artifacts = []
      owner            = "AWS"
      provider         = "ECS"
      run_order        = 1
      version          = "1"
    }
  }
}