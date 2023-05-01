########################################
# Github Deploy User
########################################

resource "aws_iam_user" "deploy_user" {
  name = "${var.project_name}-${var.env}-deploy-user"
  path = "/"
  tags = var.tags
}

// NOTE: we need to have extra policies added to our
// deploy user for Github AWS Actions to work
resource "aws_iam_user_policy" "deploy" {
  name   = "${var.project_name}_deploy_extended"
  user   = aws_iam_user.deploy_user.name
  policy = data.aws_iam_policy_document.extended_deploy.json
}

data "aws_iam_policy_document" "extended_deploy" {
  statement {
    actions = [
      "iam:PassRole",
      "ecr:InitiateLayerUpload",
    ]

    resources = [
      module.ecr_registry_base.registry_arn,
      module.ecr_registry_custom.registry_arn,
    ]
  }
}

########################################
# ECR
########################################

module "ecr_registry_base" {
  source = "github.com/developmentseed/tf-seed/modules/aws_ecr"
  environment              = var.env
  registry_name            = var.registry_name_base
  is_public                = true
  enable_registry_scanning = false
  mutable_image_tags       = true
  enable_deploy_user       = true
  iam_deploy_username      = aws_iam_user.deploy_user.name
  tags = var.tags
}

module "ecr_registry_custom" {
  source = "github.com/developmentseed/tf-seed/modules/aws_ecr"
  environment              = var.env
  is_public                = true
  registry_name            = var.registry_name_custom
  enable_registry_scanning = false
  mutable_image_tags       = true
  enable_deploy_user       = true
  iam_deploy_username      = aws_iam_user.deploy_user.name
  tags = var.tags
}
