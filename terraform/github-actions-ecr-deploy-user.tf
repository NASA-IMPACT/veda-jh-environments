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
      "s3:*",
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


########################################
# S3 Bucket Policy (cross account for SMCE role)
########################################
data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_role.iamserviceaccount.arn}"]
    }

    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.profilelist.arn,
      "${aws_s3_bucket.profilelist.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.profilelist.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

########################################
# SMCE IAM Role for K8s ServiceAccount
########################################
data "aws_iam_policy_document" "web_assume_role_policy" {
  provider = aws.smce-west1
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::444055461661:oidc-provider/oidc.eks.us-west-1.amazonaws.com/id/FB5063842FB118B7C7AF802C7E9D7631"]
    }

    condition {
      test     = "StringLike"
      variable = "oidc.eks.us-west-1.amazonaws.com/id/FB5063842FB118B7C7AF802C7E9D7631:aud"

      values = [
        "sts.amazonaws.com",
      ]
    }

    condition {
      test     = "StringLike"
      variable = "oidc.eks.us-west-1.amazonaws.com/id/FB5063842FB118B7C7AF802C7E9D7631:sub"

      # this line gives all k8s ServiceAccount(s) in the namespace 'jupyterhub' access to assume this role
      values = [
        "system:serviceaccount:jupyterhub:*",
        "system:serviceaccount:jupyterhub-v311:*",
      ]
    }
  }
}

data "aws_iam_policy_document" "inline_policy" {
  provider           = aws.smce-west1
  statement {
    actions   = ["s3:*"]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "iamserviceaccount" {
  provider           = aws.smce-west1
  name               = "${var.project_name}-${var.env}-iam-to-k8sserviceaccount-role"

  assume_role_policy = data.aws_iam_policy_document.web_assume_role_policy.json

  inline_policy {
    name             = "${var.project_name}-${var.env}-s3-full-access"
    policy           = data.aws_iam_policy_document.inline_policy.json
  }
}

#####################################
# UAH S3
#####################################
resource "aws_s3_bucket" "profilelist" {
  bucket = "${var.project_name}-${var.env}-profile-list"
  tags = var.tags
}
