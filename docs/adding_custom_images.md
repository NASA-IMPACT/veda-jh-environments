# Adding Custom Images for JupyterHub (JH) Profile

### Intro

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
$ cat Dockerfile

FROM public.ecr.aws/i8x6m1u9/pangeo-notebook:2023-05-04
ENV VERSION=0.0.1
```

The line `FROM public.ecr.aws/i8x6m1u9/pangeo-notebook:2023-05-04` shows which base image our custom image will inherit from (read more about [base images here](./base_images.md)) 
The url points to where the public image is stored on AWS ECR. It's tagged with `2023-05-04`. 

The line `ENV VERSION=0.0.1` is talked about later in this document

4. Next, notice the `envrionment.yml` file next to the `Dockerfile`. This configuration file allows us to specify additional packages that
the base image might not have (read more about finding which default packages [base images have here](./base_images.md)) :

```python
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

---

### Creating A Custom Image

1. to create your own custom environment, create a new branch off `main`:

```python
$ git checkout -b feature/new-eis-science-env
```

2. then either copy an example or manually create a folder in `/docker-images/custom/` directory with your new `Dockerfile` and `environment.yml`. 
Below we laboriously walk through the steps of copying an existing example:

3. copy an example to the `/docker-images/custom/` directory and give it a unique name
```python
$ cp -R /docker-images/examples/owslib-rio-tiler  /docker-images/custom/eis-science-env
```

4. navigate to that new directory
```python
$ cd /docker-images/custom/eis-science-env
```

5. open your `Dockerfile` and choose a base image that makes sense (read more about [base images here](./base_images.md)) 
```python
FROM public.ecr.aws/i8x6m1u9/pangeo-notebook:2023-05-04
```

6. `VERSION` is here only here as an extra tag to allow folks to bump it manually and run `docker pull public.ecr.aws/i8x6m1u9/pangeo-notebook:0.0.1` to
verify that the image is built and public. There is no need to bump the `VERSION` otherwise
```python
ENV VERSION=0.0.1
```

7. next, change your `environment.yaml` to fit your packaging needs; for example, if you don't see the packages you need in the base image
(read more about finding which default packages [base images have here](./base_images.md))

```python
dependencies:
  - pip:
    - rio-tiler==4.1.10
    - OWSLib==0.28.1
```

8. after editing your packages make sure you also change the 'name' key in the `environment.yml`
```python
name: owslib-rio-tiler
```

9. It's always a best practice that your intended environment uses either a [pinned yaml file](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html#preventing-packages-from-updating-pinning) 
or other formats. Read more about this topic in [Specifying Custom Packages](./specifying_custom_packages.md)

10. Push your changes on your feature branch up

```python
git commit -m "add new JH environ"
git push origin  feature/new-eis-science-env
```

11. Then go to this repository and open a PR against the `main` branch
