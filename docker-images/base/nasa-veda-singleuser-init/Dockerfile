# Dockerfile for base image of all pangeo images
FROM ubuntu:22.04
# build file for pangeo images

LABEL org.opencontainers.image.source=https://github.com/NASA-IMPACT/veda-jh-environments/tree/main/docker-images

ENV DEBIAN_FRONTEND=non-interactive
RUN echo "installing apt-get packages..." \
    && apt-get update --fix-missing > /dev/null \
    && apt-get install -y apt-utils git python3-pip > /dev/null \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV NB_USER=jovyan
RUN echo "creating ${NB_USER} user..." \
    # Create a group for the user to be part of, with gid same as uid
    && groupadd --gid 1000 ${NB_USER} \
    # Create non-root user, with given gid, uid and create $HOME
    && useradd --create-home --gid 1000 --no-log-init --uid 1000 ${NB_USER}

USER jovyan
WORKDIR /opt

RUN pip3 install nbgitpuller
# NOTE: the below script is used as a k8s post-start hook to copy /veda-docs repository to all user pods
COPY --chown=jovyan:jovyan ./k8s-init-container-nb-docs.py /opt/k8s-init-container-nb-docs.py
RUN chmod 777 /opt/k8s-init-container-nb-docs.py
