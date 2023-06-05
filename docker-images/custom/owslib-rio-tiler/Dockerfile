FROM public.ecr.aws/i8x6m1u9/pangeo-notebook:2c8a18b7c80359139ec8923f0a69ee5f80008c77ef430a49b90f5ce24296ebc1

# used to dynamically override `CONDA_ENV` declared in base image
# (https://github.com/pangeo-data/pangeo-docker-images/blob/master/base-image/Dockerfile#L9)
# to use name passed in as a build arg during `docker build` command
ARG CONDA_ENV_NAME_OVERRIDE
ENV CONDA_ENV=$CONDA_ENV_NAME_OVERRIDE

ENV VERSION=0.0.4
