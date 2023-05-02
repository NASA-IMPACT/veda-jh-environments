### Adding Custom Images for JupyterHub (JH) Profile

0. Navigate to `/docker-images/examples/`

1. Each folder in this directory contains configuration files for a custom image

2. For a quick example navigate to `/docker-images/examples/owslib-rio-tiler`. Note the two files
that are present in this folder. Let's talk about each one.

```python
$ ls -l
total 16
-rw-r--r--  1 ranchodeluxe  staff   86 May  1 04:23 Dockerfile
-rw-r--r--  1 ranchodeluxe  staff  130 May  1 04:47 environment.yml
```

3. Each custom image folder should at least container one `Dockerfile` similar to one below:

```python
# NOTE: you'll need to pick a base image, most folks will just need the default to be the 'pangeo-notebook' base image
# TODO: decide on which base images we want to support (look to Planetary Computer and SageMaker for advice here)
FROM public.ecr.aws/i8x6m1u9/pangeo-notebook:0.0.1

# NOTE: if a version of image already exists in the repository it won't be pushed, so bump the version if you've changed your `environment.yml`
ENV VERSION=0.0.1
```

4. Next, notice the `envrionment.yml` file next to the `Dockerfile`. This config allows us to specify additional packages that
the base image might not have:

```python
# TODO: find a link to packages that are default installed in our base images 
$ cat environment.yml
name: owslib-rio-tiler
channels:
  - conda-forge
  - defaults
dependencies:
  - pip:
    - rio-tiler==4.1.10
    - OWSLib==0.28.1
```

5. To create your own custom environment, create a new branch off `main`:

```python
$ git checkout -b feature/new-eis-science-env
```

6. Then either copy an example or manually create a folder in `/docker-images/custom/` directory. Below we walk through the
steps of copying an existing example:

```python
# copy an example to the '/docker-images/custom/' directory and give it a unique name
$ cp -R /docker-images/examples/owslib-rio-tiler  /docker-images/custom/eis-science-env

# navigate to that new directory
$ cd /docker-images/custom/eis-science-env

# open your 'Dockerfile' and choose a base image that makes sense
# TODO: decide on which base images we want to support (look to Planetary Computer and SageMaker for advice here)
FROM public.ecr.aws/i8x6m1u9/pangeo-notebook:0.0.1

# if a version of image already exists in the repository it won't be pushed, so bump the version if you've changed your `environment.yml`
ENV VERSION=0.0.1

# next, change your 'environment.yaml' to fit your packaging needs if you don't see the packages you need in the base image
# TODO: find a link to packages that are default installed in our base images 
dependencies:
  - pip:
    - rio-tiler==4.1.10
    - OWSLib==0.28.1

# after editing your packages make sure you also change the 'name' key in the `environment.yml`
name: owslib-rio-tiler
```

7. It's always a best practice that your intended environment uses either a [pinned yaml file](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html#preventing-packages-from-updating-pinning) 
or other formats. Read more about this topic in [Specifying Custom Packages](./specifying_custom_packages.md)

8. Push your changes on your feature branch up

```python
git commit -m "add new JH environ"
git push origin  feature/new-eis-science-env
```

9. Then go to this repository and open a PR against the `main` branch
