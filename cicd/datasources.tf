data "aws_codecommit_repository" "pythonapp_repo" {
  repository_name = var.project_repository_name
}