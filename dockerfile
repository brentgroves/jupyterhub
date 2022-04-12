FROM jupyter/all-spark-notebook:2022-04-04 
# docker build -t jhtest . 
# Replace `latest` with an image tag from to ensure reproducible builds:
# https://hub.docker.com/r/jupyter/minimal-notebook/tags/
# Inspect the Dockerfile at:
# https://github.com/jupyter/docker-stacks/tree/HEAD/minimal-notebook/Dockerfiles
# ENV MY_NAME="John Doe"
USER root
ENV GRANT_SUDO="yes"
ENV DEBIAN_FRONTEND noninteractive
ENV MORE=-3000

COPY PROGRESS_DATADIRECT_OPENACCESS_OAODBC_8.1.0.HOTFIX_LINUX_64.tar ./
RUN tar -xf PROGRESS_DATADIRECT_OPENACCESS_OAODBC_8.1.0.HOTFIX_LINUX_64.tar
# docker run -it -p 8888:8888 jhtest /bin/bash
# docker cp a88eeb3c44e9:/home/jovyan/unixpi.ksh ./unixpi.ksh
# docker cp ./test.py 7c988b0a6370:/home/jovyan/
# COPY ./PlexDriverInstall.py /home/jovyan/
COPY ./PlexDriverInstall.py /home/jovyan/

# docker cp ./PlexDriverInstall.py dd67e2bd92df:/home/jovyan/
# COPY ./unixpi.ksh /home/jovyan/
# sudo docker cp ./unixpi.ksh dd67e2bd92df:/home/jovyan/unixpi.ksh
# yes | ksh unixpi.ksh
# python PlexDriverInstall.py | ksh unixpi.ksh
# https://www.baeldung.com/linux/bash-interactive-prompts

# Install tools required for project
# Run `docker build --no-cache .` to update dependencies
RUN sudo apt-get update && apt-get install -y \
  ksh \
  apt-utils \
  neofetch \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  wget \
  && sudo rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
RUN sudo curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list

# RUN sudo chmod o+r /usr/share/keyrings/docker-archive-keyring.gpg
# RUN umask 000 
RUN sudo apt-get update
RUN sudo DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get install -y msodbcsql17
# optional: for bcp and sqlcmd
RUN sudo DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get install -y mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> /home/jovyan/.bashrc

RUN sudo DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get install -y msodbcsql18
# optional: for bcp and sqlcmd
RUN sudo DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get install -y mssql-tools18
RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> /home/jovyan/.bashrc
RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install -y unixodbc-dev

# install additional package...
# Install Python 3 packages
RUN mamba install --quiet --yes \
    'pyodbc'

RUN python PlexDriverInstall.py 
COPY ./odbc.ini /etc/
COPY ./odbc64.ini /usr/oaodbc81/

ENV LD_LIBRARY_PATH="/usr/oaodbc81/lib64"
ENV OASDK_ODBC_HOME="/usr/oaodbc81/lib64"
ENV ODBCINI="/usr/oaodbc81/odbc64.ini"
# LD_LIBRARY_PATH=/usr/oaodbc81/lib64${LD_LIBRARY_PATH:+":"}${LD_LIBRARY_PATH:-""}
# export LD_LIBRARY_PATH
# OASDK_ODBC_HOME=/usr/oaodbc81/lib64; export OASDK_ODBC_HOME
# ODBCINI=/usr/oaodbc81/odbc64.ini; export ODBCINI
# RUN source /usr/oaodbc81/oaodbc64.sh THIS DOES NOT DO ANYTHING

# Switch back to jovyan to avoid accidental container runs as root
USER ${NB_UID}


# set the default command of the image,
# if the parent image will not launch a jupyterhub singleuser server.
# The JupyterHub "Docker stacks" do not need to be overridden.
# Set either here or in `singleuser.cmd` in your values.yaml
# CMD ["jupyterhub-singleuser"]