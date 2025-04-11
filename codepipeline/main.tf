resource "aws_codepipeline" "app_pipeline" {
  name = "app-pipeline"
  artifact_store {
    location = aws_s3_bucket.pipeline_artifacts.bucket
    type     = "S3"
  }
  role_arn = aws_iam_role.codepipeline_role.arn

  stages {
    name = "Source"
    action {
      name             = "GitHubSource"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        Owner  = "your-github-username"
        Repo   = "your-repo-name"
        Branch = "main"
        OAuthToken = "your-github-token"
      }
    }
  }
}
