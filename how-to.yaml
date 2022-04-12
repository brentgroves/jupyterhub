docker run -it --rm \
    -p 8888:8888 \
    --user root \
    -e NB_USER="my-username" \
    -e CHOWN_HOME=yes \
    -w "/home/${NB_USER}" \
    jupyter/base-notebook

docker run -it --rm \
-p 8888:8888 \
--user root \
-e GRANT_SUDO=yes
jupyter/all-spark-notebook:2022-04-04

    Permission-specific configurations
-e NB_UMASK=<umask> - Configures Jupyter to use a different umask value from default, i.e. 022. For example, if setting umask to 002, new files will be readable and writable by group members instead of the owner only. Check this Wikipedia article for an in-depth description of umask and suitable values for multiple needs. While the default umask value should be sufficient for most use cases, you can set the NB_UMASK value to fit your requirements.

# Driver=/opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.9.so.1.1

-e GRANT_SUDO=yes - Instructs the startup script to grant the NB_USER user passwordless sudo capability. 
You do not need this option to allow the user to conda or pip install additional packages. 
This option is helpful for cases when you wish to give ${NB_USER} the ability to install OS packages with apt 
or modify other root-owned files in the container. You must run the container with --user root for this option to take effect. 
(The start-notebook.sh script will su ${NB_USER} after adding ${NB_USER} to sudoers.) 
You should only enable sudo if you trust the user or if the container is running on an isolated host.