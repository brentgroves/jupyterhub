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
# USER ${NB_UID}

# install additional package...
# Install Python 3 packages
# https://docs.manim.community/en/stable/installation.html
# https://www.dmcinfo.com/latest-thinking/blog/id/9388/how-to-upload-a-file-to-sharepoint-on-premises-using-python
# Create the environment:
# COPY env-base.yml .
# RUN conda env create -f env-base.yml

# # Make RUN commands use the new environment:
# # https://docs.conda.io/projects/conda/en/latest/commands/run.html
# SHELL ["conda", "run", "-n", "base", "/bin/bash", "-c"]

# RUN ipython kernel install --user --name=base

# Switch back to jovyan so that he is installing packages and not root
USER ${NB_UID}
WORKDIR /home/jovyan
# Since I did not have the WORKDIR command .condarc went to /root maybe this is
# why I have a [conda env:root] kernel
COPY ./.condarc /home/jovyan/

# These files are available to jovyan
# These packages are in the base env
# RUN conda install --quiet --yes \
#   'nb_conda_kernels' \
#   'zeep' \
#   'requests' \
#   'requests_ntlm' \
#   'pyodbc' \
#   'pandas' \
#   'ipykernel'
# https://stackoverflow.com/questions/55123637/activate-conda-environment-in-docker

# Since, conda run is an experimental feature the correct way is to add this line to your Dockerfile
# SHELL [ "/bin/bash", "--login", "-c" ]
# after this you can continue with
# RUN conda init bash
# and then continue to activate your environment with
# RUN conda activate <env_name>

# https://stackoverflow.com/questions/55123637/activate-conda-environment-in-docker
# this creates .bashrc with code to launch the conda.sh
# THIS WONT WORK FROM A DOCKERFILE
# RUN conda init bash 
# RUN source .bashrc
# https://rc-docs.northeastern.edu/en/latest/software/conda.html#:~:text=To%20activate%20your%20Conda%20environment,Conda%20environment%2C%20type%20conda%20deactivate%20.
COPY env-etl.yml .
RUN conda env create -f env-etl.yml

# Make RUN commands use the new environment:
# https://docs.conda.io/projects/conda/en/latest/commands/run.html
# Since, conda run is an experimental feature the correct way is to add this line to your Dockerfile
# SHELL [ "/bin/bash", "--login", "-c" ]
# after this you can continue with
# RUN conda init bash
# and then continue to activate your environment with
# RUN conda activate <env_name>
# if it works the environment is created in /home/jovyan/.local/share/jupyter/kernels
# since /home/jovyan/.local/share/jupyter/kernels/etl was not created must have failed or been created somewhere else.
# or for the base env 
# Maybe since conda is initially installed as user root that is why the conda env:root kernel is installed?


# https://stackoverflow.com/questions/67059518/configure-setting-activate-a-python-conda-environment-in-docker
# Run an executable in a conda environment.
# bash -c  If the -c option is present, then commands are read from string.
# If there are arguments after the string, they are assigned to the positional parameters, starting with $0.
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
# https://ipython.readthedocs.io/en/stable/install/kernel_install.html
RUN ipython kernel install --user --name=etl
# A ‘kernel’ is a program that runs and introspects the user’s code. IPython includes a kernel for Python code, and people have written kernels for several other languages.
# When IPython starts a kernel, it passes it a connection file. This specifies how to set up communications with the frontend.
# Kernel installs to /home/jovyan/.local/share/jupyter/kernels/
# python -m runs the script in the below case ipykernel_launcher with a specific version of python
# https://ipython.org/ipython-doc/3/development/kernels.html
# /home/jovyan/.local/share/jupyter/kernels/etl/kernel.json  
# {
#  "argv": [
#   "/home/jovyan/my-conda-envs/etl/bin/python",
#   "-m",
#   "ipykernel_launcher",
#   "-f",
#   "{connection_file}"
#  ],
#  "display_name": "etl",
#  "language": "python",
#  "metadata": {
#   "debugger": true
#  }
# }
# If I run the ipython command from a terminal the launcher sees it
# https://ipython.readthedocs.io/en/stable/install/kernel_install.html
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
# kernel installed to /home/jovyan/.local/share/jupyter/kernels/manim
# 
# Run an executable in a conda environment.
# bash -c  If the -c option is present, then commands are read from string.
# If there are arguments after the string, they are assigned to the positional parameters, starting with $0.
SHELL ["conda", "run", "-n", "base", "/bin/bash", "-c"]

# LD_LIBRARY_PATH=/usr/oaodbc81/lib64${LD_LIBRARY_PATH:+":"}${LD_LIBRARY_PATH:-""}
# export LD_LIBRARY_PATH
# OASDK_ODBC_HOME=/usr/oaodbc81/lib64; export OASDK_ODBC_HOME
# ODBCINI=/usr/oaodbc81/odbc64.ini; export ODBCINI
# RUN source /usr/oaodbc81/oaodbc64.sh THIS DOES NOT DO ANYTHING

# # Switch back to jovyan to avoid accidental container runs as root
# USER ${NB_UID}


# set the default command of the image,
# if the parent image will not launch a jupyterhub singleuser server.
# The JupyterHub "Docker stacks" do not need to be overridden.
# Set either here or in `singleuser.cmd` in your values.yaml
# CMD ["jupyterhub-singleuser"]