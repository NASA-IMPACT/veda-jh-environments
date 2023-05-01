#### We use Terraform in this repository for IAC:

0. install `tfenv` to manage multiple versions: [https://github.com/tfutils/tfenv](https://github.com/tfutils/tfenv)

1. our `init.tf` file forces us to use a `required_version = "1.3.9"` so install that:

```bash
$ tfenv list
  1.1.5
  1.1.4
  
$ tfenv install 1.3.9
$ tfenv use 1.3.9
```

2. make sure you set up an `AWS_PROFILE` in your `~/.aws/confg|credentials` files for the correct account/region

3. then: `cd /terraform/`

4. then: `AWS_PROFILE=<account> terraform init`

5. we also use Terraform "workspaces" so our infra state stays nicely separated in the same S3 bucket. Some quick samples of how to interact with that:

```bash
$ AWS_PROFILE=<account> terraform workspace list        
* default
  
$ AWS_PROFILE=<account> terraform workspace new west1-sandbox
Created and switched to workspace "west1-sandbox"!   

$ AWS_PROFILE=<account> terraform workspace list
* west1-sandbox 
```

8. finally you can `plan` and `apply` your changes:

```bash
# (where `<environment>.tf` should quite literally match the name of the workspace)
$ AWS_PROFILE=<account> terraform <plan|apply> -var-file=./vars/<environment>.tf
```
