resource "aws_s3_bucket" "cicd_bucket" {
  #   bucket = var.artifacts_bucket_name
  bucket = "artifact-codepipeline-freddieentity"
}


resource "aws_s3_bucket_acl" "cicd_bucket_acl" {
  bucket = aws_s3_bucket.cicd_bucket.id
  acl    = "private"
}