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
# https://www.edgoad.com/2021/02/using-personal-access-tokens-with-git-and-github.html
ENV GITHUB_TOKEN=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

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
# https://docs.manim.community/en/stable/installation/linux.html
RUN sudo apt-get update && apt-get install -y \
  ksh \
  apt-utils \
  neofetch \
  apt-transport-https \
  ca-certificates \
  curl \
  gpg \
  git \
  software-properties-common \
  wget \
  libcairo2-dev \
  libpango1.0-dev \
  ffmpeg \
  texlive-full \  
  && sudo rm -rf /var/lib/apt/lists/*

# https://knowledge-junction.com/2021/05/09/ubuntu-connecting-sharepoint-online-using-powershell/
# https://docs.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.2
# Download the Microsoft repository GPG keys
# RUN wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
# # Register the Microsoft repository GPG keys
# RUN dpkg -i packages-microsoft-prod.deb
# # Update the list of packages after we added packages.microsoft.com
# RUN apt-get update
# # Install PowerShell
# RUN apt-get install -y powershell

# https://www.dmcinfo.com/latest-thinking/blog/id/9388/how-to-upload-a-file-to-sharepoint-on-premises-using-python
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

RUN apt-get install -y powershell

# https://stackoverflow.com/questions/69468265/is-there-a-docker-image-with-github-cli-preinstalled
# https://stackoverflow.com/questions/63998026/how-to-run-github-cli-in-container-as-random-user
RUN chmod g+rwx -R /usr/local/bin/
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg;
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null;
RUN sudo apt-get update && apt install -y gh;


RUN python PlexDriverInstall.py 
COPY ./odbc.ini /etc/
COPY ./odbc64.ini /usr/oaodbc81/

ENV LD_LIBRARY_PATH="/usr/oaodbc81/lib64"
ENV OASDK_ODBC_HOME="/usr/oaodbc81/lib64"
ENV ODBCINI="/usr/oaodbc81/odbc64.ini"



# Switch back to jovyan to avoid accidental container runs as root
# don't need to be root for pip install
USER ${NB_UID}

# install additional package...
# Install Python 3 packages
# https://docs.manim.community/en/stable/installation.html
# https://www.dmcinfo.com/latest-thinking/blog/id/9388/how-to-upload-a-file-to-sharepoint-on-premises-using-python
# Create the environment:
COPY env-etl.yml .
RUN conda env create -f env-etl.yml

# Make RUN commands use the new environment:
# https://docs.conda.io/projects/conda/en/latest/commands/run.html
SHELL ["conda", "run", "-n", "etl", "/bin/bash", "-c"]
# Demonstrate the environment is activated:
# https://stackoverflow.com/questions/53004311/how-to-add-conda-environment-to-jupyter-lab
# RUN conda install --quiet --yes \
#   'zeep' \
#   'requests' \
#   'requests_ntlm' \
#   'pyodbc' \
#   'pandas' \
#   'ipykernel'

RUN ipython kernel install --user --name=etl
# Make RUN commands use the base environment:
# SHELL ["conda", "run", "-n", "base", "/bin/bash", "-c"]

# https://stackoverflow.com/questions/39223249/multiple-run-vs-single-chained-run-in-dockerfile-which-is-better
# https://pythonspeed.com/articles/activate-conda-dockerfile/

# Create the environment:
COPY env-manim.yml .
RUN conda env create -f env-manim.yml

# Make RUN commands use the new environment:
# https://docs.conda.io/projects/conda/en/latest/commands/run.html
SHELL ["conda", "run", "-n", "manim", "/bin/bash", "-c"]
# Demonstrate the environment is activated:
# https://stackoverflow.com/questions/53004311/how-to-add-conda-environment-to-jupyter-lab
RUN pip3 install manim 
# RUN conda install ipykernel
RUN ipython kernel install --user --name=manim
# Make RUN commands use the base environment:
SHELL ["conda", "run", "-n", "base", "/bin/bash", "-c"]

# LD_LIBRARY_PATH=/usr/oaodbc81/lib64${LD_LIBRARY_PATH:+":"}${LD_LIBRARY_PATH:-""}
# export LD_LIBRARY_PATH
# OASDK_ODBC_HOME=/usr/oaodbc81/lib64; export OASDK_ODBC_HOME
# ODBCINI=/usr/oaodbc81/odbc64.ini; export ODBCINI
# RUN source /usr/oaodbc81/oaodbc64.sh THIS DOES NOT DO ANYTHING

# Switch back to jovyan to avoid accidental container runs as root
# USER ${NB_UID}


# set the default command of the image,
# if the parent image will not launch a jupyterhub singleuser server.
# The JupyterHub "Docker stacks" do not need to be overridden.
# Set either here or in `singleuser.cmd` in your values.yaml
# CMD ["jupyterhub-singleuser"]