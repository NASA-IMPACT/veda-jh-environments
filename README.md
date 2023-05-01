## veda-jh-environments

TODO: diagram

### Adding Custom Images to JupyterHub (JH) Profile

0. Navigate to `/docker-images/custom-examples/`

1. Each folder in this directory contains configuration files for a custom image

2. The name of each folder will become the name of the image in JH profiles page that you select

3. For a quick example navigate to `/docker-images/custom-examples/owslib-rio-tiler`. Note the two files
that are present in this folder. Let's talk about each one.

```bash
$ ls -l
total 16
-rw-r--r--  1 ranchodeluxe  staff   86 May  1 04:23 Dockerfile
-rw-r--r--  1 ranchodeluxe  staff  130 May  1 04:47 environment.yml
```

4. Each custom image folder should at least container one `Dockerfile` similar to one below:

```bash
# NOTE: you need to understand which base image you'll want installed
# most folks will just need the default to be the 'pangeo-notebook' base image
# TODO: decide on which base images we want to support (look to Planetary Computer and SageMaker for advice here)
FROM public.ecr.aws/i8x6m1u9/tf-pangeo-notebook-west1-sandbox:0.0.1
# NOTE: it might also be helpful (or not) for you to edit the version number to track changes to your environment
ENV VERSION=0.0.1
```

5. Next, notice the `envrionment.yml` file next to the `Dockerfile`. This config let's us specify additional packages that
the base image might not have:

```bash
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

6. To create your own custom environment, create a new branch off `main`:

```bash
$ git checkout -b new-eis-science_env
```

7. Then either copy an example or manually create a folder in `/docker-images/` directory. Below we walk through the
steps of copying an existing example:

```bash
# copy an example to the main '/docker-images/' directory and give it a unique name
$ cp -R /docker-images/custom-examples/owslib-rio-tiler  /docker-images/eis-science-env

# navigate to that new directory
$ cd /docker-images/eis-science-env

# open your 'Dockerfile' and choose a base image that makes sense
# TODO: decide on which base images we want to support (look to Planetary Computer and SageMaker for advice here)
FROM public.ecr.aws/i8x6m1u9/tf-pangeo-notebook-west1-sandbox:0.0.1

# if needed, consider bumping your 'VERSION` in the 'Dockerfile'
ENV VERSION=0.0.1

# next, change your 'environment.yaml' to fit your packaging needs if you don't see the packages you need in the base image
# TODO: find a link to packages that are default installed in our base images 
dependencies:
  - pip:
    - rio-tiler==4.1.10
    - OWSLib==0.28.1

# after editing your packages make sure you also change the 'name' of the yaml
name: owslib-rio-tiler
```

7. It's always a best practice that your intended environment uses either a [pinned yaml file](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html#preventing-packages-from-updating-pinning) 
or other formats. Read more about this topic in [Specifying Package Versions](#specifying-package-versions)

8. Push your changes up and open PR on this repository against the `main` branch

---

### Specifying Package Versions

Most folks will want to use [pinned environment.yaml files](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html#preventing-packages-from-updating-pinning).
But below we show you how to specify your package details using [conda-lock](https://github.com/conda/conda-lock) or [conda-pack](https://conda.github.io/conda-pack/) files also


1. TOOD: talk more in depth about "pinned" yaml and requirements. Most people will be comfortable with creating `environment.yml` files. It's a best practice that all your listed 
packages here are "pinned" (read more about [pinning here](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html#preventing-packages-from-updating-pinning)). 
While the lines below functionally act as a pin, it's not a true `conda` pin b/c the dependencies of our
target packages should be pinned also:

```bash
  - pip:
    - rio-tiler==4.1.10
    - OWSLib==0.28.1
```

2. if we run `conda env export` we generate the actual pinned yaml:

```bash
name: /owslib-rio-tiler
channels:
  - conda-forge
  - defaults
dependencies:
  - _libgcc_mutex=0.1=conda_forge
  - _openmp_mutex=4.5=2_gnu
  - bzip2=1.0.8=h7f98852_4
  - ca-certificates=2022.12.7=ha878542_0
  - ld_impl_linux-64=2.40=h41732ed_0
  - libexpat=2.5.0=hcb278e6_1
  - libffi=3.4.2=h7f98852_5
  - libgcc-ng=12.2.0=h65d4601_19
  - libgomp=12.2.0=h65d4601_19
  - libnsl=2.0.0=h7f98852_0
  - libsqlite=3.40.0=h753d276_1
  - libuuid=2.38.1=h0b41bf4_0
  - libzlib=1.2.13=h166bdaf_4
  - ncurses=6.3=h27087fc_1
  - openssl=3.1.0=hd590300_2
  - pip=23.1.2=pyhd8ed1ab_0
  - python=3.11.3=h2755cc3_0_cpython
  - readline=8.2=h8228510_1
  - setuptools=67.7.2=pyhd8ed1ab_0
  - tk=8.6.12=h27826a3_0
  - tzdata=2023c=h71feb2d_0
  - wheel=0.40.0=pyhd8ed1ab_0
  - xz=5.2.6=h166bdaf_0
  - pip:
    - affine==2.4.0
    - anyio==3.6.2
    - attrs==23.1.0
    - boto3==1.26.123
    - botocore==1.29.123
    - cachetools==5.3.0
    - certifi==2022.12.7
    - charset-normalizer==3.1.0
    - click==8.1.3
    - click-plugins==1.1.1
    - cligj==0.7.2
    - color-operations==0.1.1
    - h11==0.14.0
    - httpcore==0.17.0
    - httpx==0.24.0
    - idna==3.4
    - jmespath==1.0.1
    - lxml==4.9.2
    - morecantile==3.3.0
    - numexpr==2.8.4
    - numpy==1.24.3
    - owslib==0.28.1
    - pydantic==1.10.7
    - pyparsing==3.0.9
    - pyproj==3.5.0
    - pystac==1.7.3
    - python-dateutil==2.8.2
    - pytz==2023.3
    - pyyaml==6.0
    - rasterio==1.3.6
    - requests==2.29.0
    - rio-tiler==4.1.10
    - s3transfer==0.6.0
    - six==1.16.0
    - sniffio==1.3.0
    - snuggs==1.4.7
    - typing-extensions==4.5.0
    - urllib3==1.26.15
prefix: /owslib-rio-tiler
```

3. TODO: show how to use [conda-lock](https://github.com/conda/conda-lock) instead of pinned yaml

4. TODO: show how to use [conda-pack](https://conda.github.io/conda-pack/) instead of pinned yaml


