nano ~/.condarc
envs_dirs:
  - /home/jovyan/my-conda-envs/
TRY MAKING ANOTHER IMAGE with nb_conda_kernals in the base
and copy .condarc file to /home/jovyan 
think about Using nbgitpuller to synchronize a folder

https://zero-to-jupyterhub.readthedocs.io/en/latest/jupyterhub/customizing/user-environment.html


conda env list
conda install nb_conda_kernels
conda create -n myenv python=3.10
conda activate myenv
source .bashrc
conda activate manim
ipython kernel install --user --name=manim
envs_dirs:
  - /home/jovyan/my-conda-envs/

Questions:
How to uninstall a release:
helm upgrade --cleanup-on-fail   --install helm-release-frt jupyterhub/jupyterhub   --namespace k8s-namespace-frt   --create-namespace   --values config.yaml


How to do updates:
Make changes to config.yml file.
Then run:
helm upgrade --cleanup-on-fail \
>     helm-release-frt jupyterhub/jupyterhub \
>   --namespace k8s-namespace-frt \
>   --version=1.2.0 \
>   --values config.yaml
https://zero-to-jupyterhub.readthedocs.io/en/latest/

Learn about kubernetes:
https://kubernetes.io/docs/setup/
https://zero-to-jupyterhub.readthedocs.io/en/latest/resources/glossary.html#term-Kubernetes

Learn about helm:
https://helm.sh/docs/

A Chart is a Helm package. It contains all of the resource definitions necessary to run an application, tool, or service inside of a Kubernetes cluster. Think of it like the Kubernetes equivalent of a Homebrew formula, an Apt dpkg, or a Yum RPM file.

A Repository is the place where charts can be collected and shared. It's like Perl's CPAN archive or the Fedora Package Database, but for Kubernetes packages.

A Release is an instance of a chart running in a Kubernetes cluster. One chart can often be installed many times into the same cluster. And each time it is installed, a new release is created. Consider a MySQL chart. If you want two databases running in your cluster, you can install that chart twice. Each one will have its own release, which will in turn have its own release name.

With these concepts in mind, we can now explain Helm like this:

Helm installs charts into Kubernetes, creating a new release for each installation. And to find new charts, you can search Helm chart repositories.



Kubernetes on a Bare Metal Host with MicroK8s
https://zero-to-jupyterhub.readthedocs.io/en/latest/kubernetes/other-infrastructure/step-zero-microk8s.html
If you have server hardware available and a small enough user base it’s possible to use Canonical’s MicroK8s in place of a cloud vendor.
With no ability to scale, users will not be able to access their notebooks when memory and CPU resources are exhausted. Read the section on resource planning and set resource limits accordingly.

A cloud provider such as Google Cloud, Microsoft Azure, Amazon EC2, IBM Cloud…
Kubernetes to manage resources on the cloud
Helm v3 to configure and control the packaged JupyterHub installation
JupyterHub to give users access to a Jupyter computing environment
A terminal interface on some operating system

helm, the package manager for Kubernetes, is a useful command line tool for: installing, upgrading and managing applications on a Kubernetes cluster. Helm packages are called charts. We will be installing and managing JupyterHub on our Kubernetes cluster using a Helm chart.

Charts are abstractions describing how to install packages onto a Kubernetes cluster. When a chart is deployed, it works as a templating engine to populate multiple yaml files for package dependencies with the required variables, and then runs kubectl apply to apply the configuration to the resource and install the package.

Any questions:
If you have questions, please:

  1. Read the guide at https://z2jh.jupyter.org
  2. Ask for help or chat to us on https://discourse.jupyter.org/
  3. If you find a bug please report it at https://github.com/jupyterhub/zero-to-jupyterhub-k8s/issues

Your release is named "helm-release-frt" and installed into the namespace "k8s-namespace-frt".

You can check whether the hub and proxy are ready by running:
 kubectl --namespace=k8s-namespace-frt get pod

To get full information about the JupyterHub proxy service run:
  kubectl --namespace=k8s-namespace-frt get svc proxy-public

You can find the public (load-balancer) IP of JupyterHub by running:
  kubectl -n k8s-namespace-frt get svc proxy-public -o jsonpath='{.status.loadBalancer.ingress[].ip}'

How do you uninstall a release?
helm uninstall helm-release-frt --namespace k8s-namespace-frt


docker run -it --rm \
    -p 8888:8888 \
    --user root \
    -e NB_USER="my-username" \
    -e CHOWN_HOME=yes \
    -w "/home/${NB_USER}" \
    jupyter/base-notebook

How do you run jupyterhub as root?
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