FROM pangeo/pangeo-notebook:2022.12.07

# reasoning to use ONBUILD below from JH: https://github.com/pangeo-data/pangeo-docker-images/blob/master/base-image/Dockerfile#L83-L96
# if override arg passed then use that instead of default in base image
# (https://github.com/pangeo-data/pangeo-docker-images/blob/master/base-image/Dockerfile#L9)
ONBUILD ARG CONDA_ENV_NAME_OVERRIDE=$CONDA_ENV
ONBUILD ARG CONDA_ENV_NAME=$CONDA_ENV_NAME_OVERRIDE
ONBUILD COPY --chown=jovyan:jovyan . /home/jovyan/custom

# below snippet taken and modified from JH images: https://github.com/pangeo-data/pangeo-docker-images/blob/master/base-image/Dockerfile#L141-L153
ONBUILD RUN echo "Checking for 'environment.yml' or 'conda-linux-64.lock'..." \
        ; if test -f "custom/standalone-environment.yml" ; then \
        echo "[ CREATE STANDALONE ENV RUNNING ]:..." && mamba create --name ${CONDA_ENV_NAME} -f custom/standalone-environment.yml \
        ; elif test -f "custom/environment.yml" ; then \
        echo "[ CREATE ENV RUNNING ]:..." && \
            mamba create --name ${CONDA_ENV_NAME} --file conda-linux-64.lock &&  \
            mamba env update --name ${CONDA_ENV_NAME} -f custom/environment.yml  \
        ; elif test -f "custom/conda-linux-64.lock" ; then \
        mamba create --name ${CONDA_ENV_NAME} --file custom/conda-linux-64.lock \
        ; else echo "No conda-linux-64.lock, or environment.yml! *creating default env*" ; \
        mamba create --name ${CONDA_ENV_NAME} pangeo-notebook \
        ; fi \
        && mamba clean -yaf \
        && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete;



