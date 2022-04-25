FROM jupyter/all-spark-notebook:2022-04-04 
USER root
ENV GRANT_SUDO="yes"
ENV DEBIAN_FRONTEND noninteractive
ENV MORE=-3000
# https://www.edgoad.com/2021/02/using-personal-access-tokens-with-git-and-github.html
ENV GITHUB_TOKEN=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

COPY ./.bashrc /opt/conda/
RUN cat /opt/conda/.bashrc >> /etc/bash.bashrc

COPY PROGRESS_DATADIRECT_OPENACCESS_OAODBC_8.1.0.HOTFIX_LINUX_64.tar ./
RUN tar -xf PROGRESS_DATADIRECT_OPENACCESS_OAODBC_8.1.0.HOTFIX_LINUX_64.tar
COPY ./PlexDriverInstall.py /home/jovyan/

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
  && sudo rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
RUN sudo curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN sudo apt-get update
RUN sudo DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get install -y msodbcsql17
RUN sudo DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get install -y mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> /home/jovyan/.bashrc

RUN sudo DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get install -y msodbcsql18
RUN sudo DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get install -y mssql-tools18
RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> /home/jovyan/.bashrc
RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install -y unixodbc-dev

RUN apt-get install -y powershell

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

COPY env-etl.yml .
RUN conda install --quiet --yes nb_conda_kernels \ 
    && conda env create -f env-etl.yml

SHELL ["conda", "run", "-n", "etl", "/bin/bash", "-c"]
#jupyter kernelspec uninstall python3 

# RUN conda install --quiet --yes ipykernel \
    # && conda install --quiet --yes -c conda-forge ipython-sql matplotlib \
    # && conda install --quiet --yes -c anaconda sqlalchemy \
    # && ipython kernel install --user --name=etl --display-name "Python (ETL)"
RUN ipython kernel install --user --name=etl --display-name "Python (ETL)"

COPY env-manim.yml .
RUN conda env create -f env-manim.yml

SHELL ["conda", "run", "-n", "manim", "/bin/bash", "-c"]
#jupyter kernelspec uninstall python3 

RUN pip3 install manim \
    && ipython kernel install --user --name=manim --display-name "Python (manim)" 

# RUN conda install --quiet --yes ipykernel \
#     && pip3 install manim \
#     && ipython kernel install --user --name=manim --display-name "Python (manim)" 

RUN chmod -R 777 /opt/conda/envs
# RUN chmod 777 /opt/conda/envs/etl 
# RUN chmod 777 /opt/conda/envs/manim

# Switch back to jovyan to avoid accidental container runs as root
USER ${NB_UID}


# set the default command of the image,
# if the parent image will not launch a jupyterhub singleuser server.
# The JupyterHub "Docker stacks" do not need to be overridden.
# Set either here or in `singleuser.cmd` in your values.yaml
# CMD ["jupyterhub-singleuser"]