FROM pangeo/pangeo-notebook:2023.04.15

# NOTE: reasoning to use ONBUILD below from JH: https://github.com/pangeo-data/pangeo-docker-images/blob/master/base-image/Dockerfile#L83-L96
# NOTE: below snippet taken and modified from JH images: https://github.com/pangeo-data/pangeo-docker-images/blob/master/base-image/Dockerfile#L141-L153
RUN echo "[ CONDA_ENV ]: ${CONDA_ENV}"
ONBUILD RUN echo "Checking for 'conda-lock.yml' 'conda-linux-64.lock' or 'environment.yml'..." \
        ; if test -f "environment.yml" ; then \
        mamba env update --name ${CONDA_ENV} -f environment.yml \
        #mamba env create --name ${CONDA_ENV} -f environment.yml  \
        ; elif test -f "conda-linux-64.lock" ; then \
        mamba create --name ${CONDA_ENV} --file conda-linux-64.lock \
        ; else echo "No conda-lock.yml, conda-linux-64.lock, or environment.yml! *creating default env*" ; \
        mamba create --name ${CONDA_ENV} pangeo-notebook \
        ; fi \
        && mamba clean -yaf \
        && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete;



