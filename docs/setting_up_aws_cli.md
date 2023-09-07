# AWS CLI Setup

For new users this is just a helper guide pointing to AWS docs for the AWS UAH account 853558080719

---

### Create a CLI Access Key

0. Login with your username and credentials here: `https://853558080719.signin.aws.amazon.com/console`

1. Walk through the [AWS documentation for creating AWS AccessKeys](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey).
This step creates secrets that you'll save locally so that the AWS CLI tool can use them.

2. Walk through the [AWS documentation for setting up local credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).
This helps the AWS CLI tool automatically grab the credentials you created in the last section automagically.

For example, my local config/credentials files for UAH look like this:

```bash
(venv_py39) $ cat ~/.aws/config 
[profile uah1]
region=us-west-1
```

```bash
(venv_py39) $ cat ~/.aws/credentials 
[uah1]
aws_access_key_id=<your-access-key-id>
aws_secret_access_key=<your-secret-access-key>
```

4. Walk through the [AWS documentaion for installing AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

### Do a quick test

0. The documentation above should already do this but you can make sure. This assumes you have your AWS credentials/config setup with under
the name `uah1` like I show above. Just replace that name with your own for `AWS_PROFILE=uah`:

```bash
(venv_py39) $ AWS_PROFILE=uah1 aws sts get-caller-identity
{
    "UserId": "AIDA4NPAGWTHDFSDDF",
    "Account": "853558080719",
    "Arn": "arn:aws:iam::853558080719:user/<your-aws-username>"
}
```
