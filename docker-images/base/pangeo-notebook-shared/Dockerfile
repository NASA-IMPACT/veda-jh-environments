FROM pangeo/pangeo-notebook:2022.12.07

# NOTE: reasoning to use ONBUILD below from JH: https://github.com/pangeo-data/pangeo-docker-images/blob/master/base-image/Dockerfile#L83-L96
# if override arg passed then use that instead of default in base image
# (https://github.com/pangeo-data/pangeo-docker-images/blob/master/base-image/Dockerfile#L9)
ONBUILD ARG CONDA_ENV_NAME_OVERRIDE=$CONDA_ENV
ONBUILD ARG CONDA_ENV_NAME=$CONDA_ENV_NAME_OVERRIDE
ONBUILD COPY --chown=jovyan:jovyan . /home/jovyan

# NOTE: below snippet taken and modified from JH images: https://github.com/pangeo-data/pangeo-docker-images/blob/master/base-image/Dockerfile#L141-L153
ONBUILD RUN echo "Checking for environment files in '*.yml' ..."; \
    SHARED_ENVIRONMENTS=$(find ./environments/*.yml); \
    for SHARED_ENVIRONMENTS_PATH in $SHARED_ENVIRONMENTS; do \
        printf "[ FOUND ]: %s\n" $SHARED_ENVIRONMENTS_PATH; \
        CONDA_ENV_W_EXT=$(echo $SHARED_ENVIRONMENTS_PATH | cut -d'/' -f 3); \
        CONDA_ENV_NAME=$(basename $CONDA_ENV_W_EXT .yml); \
        mamba env create --name ${CONDA_ENV_NAME} -f $SHARED_ENVIRONMENTS_PATH; \
    done;
