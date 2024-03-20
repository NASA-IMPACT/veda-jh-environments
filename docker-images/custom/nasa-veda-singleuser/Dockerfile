FROM public.ecr.aws/i8x6m1u9/pangeo-notebook:latest@sha256:f2e7371afddb89392b684097ebfa699a7a6c04936554e474f01cb673d024b235
# above hash is JH version 4.x
ENV VERSION=0.0.3
# NOTE: the below script is used as a k8s post-start hook to copy /veda-docs repository to all user pods
COPY --chown=jovyan:jovyan ./k8s-lifecycle-hook-post-start.py /opt/k8s-lifecycle-hook-post-start.py
RUN chmod +x /opt/k8s-lifecycle-hook-post-start.py
