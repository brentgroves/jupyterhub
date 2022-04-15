nano ~/.condarc
envs_dirs:
  - /home/jovyan/my-conda-envs/
TRY MAKING ANOTHER IMAGE with nb_conda_kernals in the base
and copy .condarc file to /home/jovyan 
think about Using nbgitpuller to synchronize a folder

https://zero-to-jupyterhub.readthedocs.io/en/latest/jupyterhub/customizing/user-environment.html


conda env list
source .bashrc

conda install nb_conda_kernels
conda create -n myenv python=3.10
conda activate myenv
source .bashrc
conda activate manim
ipython kernel install --user --name=manim
envs_dirs:
  - /home/jovyan/my-conda-envs/

Questions:
How are different users handled?  Each one gets a new pod.

After env got working will a new user see them?

How are env handled in JupyterLab? https://github.com/Anaconda-Platform/nb_conda_kernels
nb_conda_kernels
This extension enables a Jupyter Notebook or JupyterLab application in one conda environment to access kernels for Python, R, and other languages found in other environments. When a kernel from an external environment is selected, the kernel conda environment is automatically activated before the kernel is launched. This allows you to utilize different versions of Python, R, and other languages from a single Jupyter installation.

The package works by defining a custom KernelSpecManager that scans the current set of conda environments for kernel specifications. It dynamically modifies each KernelSpec so that it can be properly run from the notebook environment. When you create a new notebook, these modified kernels will be made available in the selection list.

This package is designed to be managed solely using conda. It should be installed in the environment from which you run Jupyter Notebook or JupyterLab. This might be your base conda environment, but it need not be. For instance, if the environment notebook_env contains the notebook package, then you would run

conda install nb_conda_kernels
conda install -n manim nb_conda_kernels



Debug:
https://kubernetes.io/docs/tasks/debug-application-cluster/get-shell-running-container/
kubectl exec --stdin --tty jupyter-t3 -- /bin/bash

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
interacts directly with the Kubernetes API server to install, upgrade, query, and remove Kubernetes resources.


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

How do you stop a release? you dont
https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/


How do find releases.
Your release is named "helm-release-frt" and installed into the namespace "k8s-namespace-frt".
helm list --namespace=k8s-namespace-frt
helm list --all-namespaces

How do you find all the resources managed by a release?
 kubectl --namespace=k8s-namespace-frt get all // this is the best way unless your chart has recommended labels

helm get all helm-release-frt --namespace=k8s-namespace-frt // This return too much info
Answer is to use K8s label.
What is a label? It is used by Kubernetes to identify this resource
Helm itself never requires that a particular label be present. Labels that are marked REC are recommended, and should be placed onto a chart for global

To list all resources managed by the helm and part of a specific release: (edit release-name)
kubectl get all --all-namespaces -l='app.kubernetes.io/managed-by=Helm,app.kubernetes.io/instance=release-name'
Update: Labels key may vary over time, follow the official documentation for the latest labels.

kubectl get all --all-namespaces -l='app.kubernetes.io/instance=helm-release-frt'
kubectl get all --all-namespaces -l='helm.sh/chart=jupyterhub-1.2.0'



You can check whether the hub and proxy are ready by running:
 kubectl --namespace=k8s-namespace-frt get pod

To get full information about the JupyterHub proxy service run:
  kubectl --namespace=k8s-namespace-frt get svc proxy-public

You can find the public (load-balancekubectl --namespace=k8s-namespace-frt get allr) IP of JupyterHub by running:
  kubectl -n k8s-namespace-frt get svc proxy-public -o jsonpath='{.status.loadBalancer.ingress[].ip}'


how do tell helm what repo to get chart from? jupyterhub/jupyterhub

How to install a release:
helm upgrade --cleanup-on-fail \
  --install helm-release-frt jupyterhub/jupyterhub \
  --namespace k8s-namespace-frt \
  --create-namespace \
  --version=1.2.0 \
  --values config.yaml
helm upgrade --cleanup-on-fail   --install helm-release-frt jupyterhub/jupyterhub   --namespace k8s-namespace-frt   --create-namespace   --values config.yaml

How to list releases? helm list --namespace=k8s-namespace-frt
helm list --all-namespaces

How to update a deployment:
Make changes to config.yml file.
Then run:
helm upgrade --cleanup-on-fail \
>     helm-release-frt jupyterhub/jupyterhub \
>   --namespace k8s-namespace-frt \
>   --version=1.2.0 \
>   --values config.yaml
How to update a release? helm upgrade --cleanup-on-fail   helm-release-frt jupyterhub/jupyterhub   --namespace k8s-namespace-frt   --version=1.2.0
helm upgrade --cleanup-on-fail \
    helm-release-frt jupyterhub/jupyterhub \
  --namespace k8s-namespace-frt \
  --version=1.2.0 \
  --values config.yaml


How do you uninstall a release?
It removes all of the resources associated with the last release of the chart as well as the release history, freeing it up for future use.
helm uninstall helm-release-frt --namespace k8s-namespace-frt

How do you delete a namespace?
kubectl delete namespace k8s-namespace-frt


What is the difference between uninstalling a release and deleting a namespace?
Doing helm uninstall ...  won't just remove the pod, but it will remove all the resources created by helm when it installed the chart. For a single pod, this might not be any different to using kubectl delete... but when you have tens or hundreds of different resources and dependent charts, doing all this manually by doing kubectl delete... becomes cumbersome, time-consuming and error-prone.

Generally if you're deleting something off the cluster, use the same method you used to install it in in the first place. If you used helm to install it into the cluster, use helm to remove it. If you used kubectl create or kubectl apply, use kubectl delete to remove it.
I will add a point that we use, quite a lot. helm uninstall/install/upgrade has hooks attached to its lifecycle. This matters a lot, here is a small example.

We have database scripts that are run as part of a job. Say you prepare a release with version 1.2.3 and as part of that release you add a column in a table - you have a script for that (liquibase/flyway whatever) that will run automatically when the chart is installed. In plain english helm install allows you to say in this case : "before installing the code, upgrade the DB schema". This is awesome and allows you to tie the lifecycle of such scripts, to the lifecycle of the chart.

The same works for downgrade, you could say that when you downgrade, revert the schema, or take any needed action. kubectl delete simply does not have such functionality.

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