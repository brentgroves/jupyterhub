FROM jupyter/all-spark-notebook:2022-04-04 
# Replace `latest` with an image tag from to ensure reproducible builds:
# https://hub.docker.com/r/jupyter/minimal-notebook/tags/
# Inspect the Dockerfile at:
# https://github.com/jupyter/docker-stacks/tree/HEAD/minimal-notebook/Dockerfile
# ENV MY_NAME="John Doe"
USER root
ENV GRANT_SUDO="yes"
# install additional package...
# RUN pip install --no-cache-dir astropy

# Install tools required for project
# Run `docker build --no-cache .` to update dependencies
RUN sudo apt-get update && apt-get install -y \
  neofetch
#   bzr \
#   cvs \
#   git \
#   mercurial \
#   subversion \
#   && rm -rf /var/lib/apt/lists/*
# set the default command of the image,
# if the parent image will not launch a jupyterhub singleuser server.
# The JupyterHub "Docker stacks" do not need to be overridden.
# Set either here or in `singleuser.cmd` in your values.yaml
# CMD ["jupyterhub-singleuser"]