FROM public.ecr.aws/nasa-veda/pangeo-notebook:60b023fba2ca5f9e19d285c245987e368e27c0ea626b65777b204cec14b697c7
# above hash is JH version 4.x
ENV VERSION=0.0.2
# NOTE: the below script is used as a k8s post-start hook to copy /veda-docs repository to all user pods
COPY --chown=jovyan:jovyan ./k8s-lifecycle-hook-post-start.py /opt/k8s-lifecycle-hook-post-start.py
RUN chmod +x /opt/k8s-lifecycle-hook-post-start.py
