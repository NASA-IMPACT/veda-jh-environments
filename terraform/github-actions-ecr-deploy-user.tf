########################################
# Github Deploy User
########################################
resource "aws_iam_user" "deploy_user" {
  name = "${var.project_name}-${var.env}-deploy-user"
  path = "/"
  tags = var.tags
}

data "aws_iam_policy_document" "deploy" {
  statement {
    # TODO: figure out which actions to limit later once we've plumbed out all the CI/CD github actions calls from awscli
    actions = [
      "iam:PassRole",
      "sts:GetServiceBearerToken",
      "ecr-public:*",
      "ecr:*",
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_user_policy" "deploy" {
  name   = "${var.project_name}-${var.env}-deploy-policy"
  user   = aws_iam_user.deploy_user.name
  policy = data.aws_iam_policy_document.deploy.json
}
