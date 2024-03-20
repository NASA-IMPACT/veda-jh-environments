FROM public.ecr.aws/nasa-veda/pangeo-notebook:f50bcca857337dab6b3dd1d7841613dfc5c92a1331d4ac65f3efb2e4ada79d91
# above hash is JH version 4.x
ENV VERSION=0.0.3
# NOTE: the below script is used as a k8s post-start hook to copy /veda-docs repository to all user pods
COPY --chown=jovyan:jovyan ./k8s-lifecycle-hook-post-start.py /opt/k8s-lifecycle-hook-post-start.py
RUN chmod +x /opt/k8s-lifecycle-hook-post-start.py
