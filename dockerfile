# https://github.com/brentgroves/jupyterhub.github
# https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html
FROM jupyter/all-spark-notebook:latest
# docker pull jupyter/all-spark-notebook:latest
# https://zero-to-jupyterhub.readthedocs.io/en/latest/jupyterhub/customizing/user-environment.html#choose-and-use-an-existing-docker-image
FROM jupyter/minimal-notebook:latest
# Replace `latest` with an image tag from to ensure reproducible builds:
# https://hub.docker.com/r/jupyter/minimal-notebook/tags/
# Inspect the Dockerfile at:
# https://github.com/jupyter/docker-stacks/tree/HEAD/minimal-notebook/Dockerfile

# install additional package...
RUN pip install --no-cache-dir astropy

# set the default command of the image,
# if the parent image will not launch a jupyterhub singleuser server.
# The JupyterHub "Docker stacks" do not need to be overridden.
# Set either here or in `singleuser.cmd` in your values.yaml
# CMD ["jupyterhub-singleuser"]