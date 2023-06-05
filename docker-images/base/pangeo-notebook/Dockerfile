FROM pangeo/pangeo-notebook:2023.04.15

# NOTE: reasoning to use ONBUILD below from JH: https://github.com/pangeo-data/pangeo-docker-images/blob/master/base-image/Dockerfile#L83-L96
# NOTE: below snippet taken and modified from JH images: https://github.com/pangeo-data/pangeo-docker-images/blob/master/base-image/Dockerfile#L141-L153
RUN mkdir /home/jovyan/custom
ONBUILD COPY --chown=jovyan:jovyan . /home/jovyan/custom
ONBUILD RUN echo "Checking for 'environment.yml' or 'conda-linux-64.lock'..." \
        ; if test -f "./custom/update-environment.yml" ; then \
        echo "[ UPDATE ENV RUNNING ]:..." \
        mamba env update --name notebook -f ./custom/update-environment.yml \
        ; elif test -f "./custom/create-environment.yml" ; then \
        echo "[ CREATE ENV RUNNING ]:..." \
        mamba env create --name ${CONDA_ENV} -f ./custom/create-environment.yml  \
        ; elif test -f "./custom/environment.yml" ; then \
        echo "[ CREATE ENV RUNNING ]:..." \
        mamba env create --name ${CONDA_ENV} -f ./custom/environment.yml  \
        ; elif test -f "./custom/conda-linux-64.lock" ; then \
        mamba create --name ${CONDA_ENV} --file ./custom/conda-linux-64.lock \
        ; else echo "No conda-linux-64.lock, or environment.yml! *creating default env*" ; \
        mamba create --name ${CONDA_ENV} pangeo-notebook \
        ; fi \
        && mamba clean -yaf \
        && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
        && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete;



