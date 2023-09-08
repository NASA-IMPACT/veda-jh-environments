FROM public.ecr.aws/nasa-veda/pangeo-notebook:56cc88560df6cf444d49af7d8f0f7a340d412ce0f10ab441254cb712b9480281
# above hash is JH version 4.x
ENV VERSION=0.0.1
# NOTE: the below script is used as a k8s post-start hook to copy /veda-docs repository to all user pods
COPY --chown=jovyan:jovyan ./k8s-lifecycle-hook-post-start.py /opt/k8s-lifecycle-hook-post-start.py
RUN chmod +x /opt/k8s-lifecycle-hook-post-start.py
