# Updating 2i2c's Singleuser Image for VEDA JH Hubs

JupyterHub configuration has the concept of a `singleuser` image that is the 
[default image for spinning up user pods](https://z2jh.jupyter.org/en/stable/jupyterhub/customizing/user-environment.html#choose-and-use-an-existing-docker-image).

Currently https://staging.nasa-veda.2i2c.cloud/ and https://nasa-veda.2i2c.cloud/ both use the custom image from this repository 
(`./docker-images/custom/nasa-veda-singleuser`) as the default. 
Below we walk through how to update this image and get it in these VEDA JH instances. This allows us to add 
custom packages without us needing to request these custom packages upstream in the `pangeonotebook` image.

## Update the Conda Environment

1. Clone this repo

2. Create a new branch `git checkout -b feature/update_package_<xyz>`

3. and open `./docker-images/custom/nasa-veda-singleuser/environment.yml`. It might look something like this: 

```yaml
channels:
  - conda-forge
  - defaults
dependencies:
  - ipykernel
  - pip
  - pip:
    - git+https://github.com/MAAP-Project/stac_ipyleaflet.git@v0.3.0
```

4. Add the pip packages or conda packages you need installed in the `dependencies` block

5. commit and push changes to the remote feature branch and create a PR

6. once the PR is merged an image building pipeline will kick off in [GH actions](https://github.com/NASA-IMPACT/veda-jh-environments/actions)

![](./images/gh_action.png)

## Get sha256sum Tag of the Image

0. you'll need `jq` utility to help parse and run functions on the AWS CLI JSON output. Install with `brew install jq`

1. The image building pipeline [creates various tags](https://github.com/NASA-IMPACT/veda-jh-environments/blob/main/.github/workflows/docker-custom-images-gha.yaml#L67-L80
) for the image but the one we want to use is the sha256sum of the `environment.yml` 

2. Get the newest image tag by querying ECR with `aws-cli` where `AWS_PROFILE=uah` points to your `AWS_PROFILE` for AWS Account ID `853558080719`.
The command below sorts our image tags by `createdAt` in the AWS CLI query and then we use `jq` to filter only the sha256sums. Since they
are sorted by `createdAt` ascending we'll want to grab the last one in the output which is `5068290376e8c3151d97a36ae6485bb7ff79650b94aecc93ffb2ea1b42d76460`
below:

```bash
$ AWS_PROFILE=uah aws ecr-public describe-image-tags \
    --repository-name nasa-veda-singleuser \
    --region us-east-1 \
    --query 'sort_by(imageTagDetails,& createdAt)' \
     | jq '.[] | select(.imageTag | test("^[a-fA-F0-9]{1,64}$"))'

{
  "imageTag": "fb40f1fcd74de7ec270d07b7acec184a916b4288098dde951e3d910ac5e35ba5",
  "createdAt": "2023-09-05T13:13:49.309000-07:00",
  "imageDetail": {
    "imageDigest": "sha256:2bac0a1d831dbad33ab8b9349892de69982bc3ed0caaf988472e45dedb094bb7",
    "imageSizeInBytes": 2667381776,
    "imagePushedAt": "2023-09-05T13:13:45.293000-07:00",
    "imageManifestMediaType": "application/vnd.docker.distribution.manifest.v2+json",
    "artifactMediaType": "application/vnd.docker.container.image.v1+json"
  }
}
{
  "imageTag": "ff1d8629d2e646942a11ba5af4f078f3a3edb06962e7da9903e7f321f2c08cbe",
  "createdAt": "2023-09-06T11:48:36.987000-07:00",
  "imageDetail": {
    "imageDigest": "sha256:58863497feeb021bd9780c5086d4fa5586f4a0126158844b22d4af4bd196a4f9",
    "imageSizeInBytes": 2667372258,
    "imagePushedAt": "2023-09-06T11:48:32.974000-07:00",
    "imageManifestMediaType": "application/vnd.docker.distribution.manifest.v2+json",
    "artifactMediaType": "application/vnd.docker.container.image.v1+json"
  }
}
{
  "imageTag": "5068290376e8c3151d97a36ae6485bb7ff79650b94aecc93ffb2ea1b42d76460",
  "createdAt": "2023-09-06T12:14:18.371000-07:00",
  "imageDetail": {
    "imageDigest": "sha256:162641a138c0f4e6eee9b3cfd6288e84f3dbbc712d69a53a96e5291de381c0fb",
    "imageSizeInBytes": 2667375957,
    "imagePushedAt": "2023-09-06T12:14:14.313000-07:00",
    "imageManifestMediaType": "application/vnd.docker.distribution.manifest.v2+json",
    "artifactMediaType": "application/vnd.docker.container.image.v1+json"
  }
}
```

## Put in a PR against 2i2c's Infrastructure Repo

1. If you haven't already [clone DS's fork](https://github.com/developmentseed/infrastructure/) of [2i2c's insfrastructure repo](https://github.com/2i2c-org/infrastructure)

2. In `config/clusters/nasa-veda/common.values.yaml` you'll see the `singleuser` image block and tags. Update the tag with the `sha` from the last step. Also update the sha in the `image` key
located at `profile_options.image.options.pangeo.kubespawner_override.image`. Probably best to refer to a past [PR over here](https://github.com/2i2c-org/infrastructure/pull/3106/files)

3. Since we don't have an accessible k8s cluster to play with the best option is to use the existing hub's "Other" option where we can try out our
custom image by referring to it. Then to doubley make sure things work we can explicitly as in PR for 2i2c to update https://staging.nasa-veda.2i2c.cloud/ first 
so we can play with it and then if all looks good we can alert them to promote it to https://nasa-veda.2i2c.cloud/

4. After the PR is in we drink some coffee and wait for 2i2c to do the work

