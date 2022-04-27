https://www.mirantis.com/blog/introduction-to-yaml-creating-a-kubernetes-deployment/
kubectl describe deployment rss-site
kubectl delete deploy rss-site

https://microk8s.io/docs/services-and-ports
Upon deployment MicroK8s creates a Certificate Authority, a signed server certificate and a service account key file. These files are stored under /var/snap/microk8s/current/certs/. Kubelet and the API server are aware of the same CA and so the signed server certificate is used by the API server to authenticate with kubelet (--kubelet-client-certificate).
printenv $KUBECONFIG
Certificate Authority
kubectl cluster-info

https://microk8s.io/docs/clustering
From the node you wish to join to this cluster, run the following:
microk8s join 172.20.1.190:25000/79aea7091d6795599b912f8ec434c8c7/b8a7ad089308

Use the '--worker' flag to join a node as a worker not running the control plane, eg:
microk8s join 172.20.1.190:25000/79aea7091d6795599b912f8ec434c8c7/b8a7ad089308 --worker

If the node you are adding is not reachable through the default interface you can use one of the following:
microk8s join 172.20.1.190:25000/79aea7091d6795599b912f8ec434c8c7/b8a7ad089308
microk8s join 172.17.0.1:25000/79aea7091d6795599b912f8ec434c8c7/b8a7ad089308
(b

If 2 people login with the same username they can see what each other is typing in a terminal but 
they can't see the updates to a notebook.
What happens when a user logs out? Sometimes his pod disappears. But if he logs in again it reappears.
If he logs in again after his pod disappears he will have to select an environment again.
What happens if when he logs in he selects a new environment?

https://zero-to-jupyterhub.readthedocs.io/en/latest/jupyterhub/customizing/user-environment.html
ipython was update. this may be a problem. 
Original jupyterhub version: 6.11.0-py39hef51801_2 
after ipython was installed: Installed kernelspec etl in /home/jovyan/.local/share/jupyter/kernels/etl
the only difference from 1.0 is that I believe nb_conda_kernels was installed in the base environment and 
the .condarc file was created.
I ran this as a local server and saw that there were 2 kernels for every environment 1 jovyan and 1 for root.
and both etl and manim showed up in /home/jovyan/my-conda-envs/.

Add these steps to dockerfile:

conda install nb_conda_kernels
create /home/jovyan/.condarc
envs_dirs:
  - /home/jovyan/my-conda-envs/
conda init bash // this modified/created .bashrc
source .bashrc
ipython kernel install --user --name=myenv
Installed kernelspec myenv in /home/jovyan/.local/share/jupyter/kernels/myenv
conda activate manim
ipython kernel install --user --name=manim
Installed kernelspec myenv in /home/jovyan/.local/share/jupyter/kernels/manim
conda activate etl
ipython kernel install --user --name=etl
Installed kernelspec myenv in /home/jovyan/.local/share/jupyter/kernels/etl

conda create -n myenv python=3.10
conda activate myenv
conda activate manim
ipython kernel install --user --name=manim
envs_dirs:
  - /home/jovyan/my-conda-envs/

Questions:
How are different users handled?  Each one gets a new pod.
There prompt is jovyan@jupyter-username and there is a .cache,.ipython,.jupyter,and .local/share/jupyter/runtime/jpserver-9.json file
base_url:/usr/env3
pid:9
root_dir:/home/jovyan
url:http://jupyter-env3:8888/usr/env3

/etc/environment contains the path

After env got working will a new user see them? No.

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
kubectl --namespace=k8s-namespace-frt get all // check the resources before the uninstall
It removes all of the resources associated with the last release of the chart as well as the release history, freeing it up for future use.
helm uninstall helm-release-frt --namespace k8s-namespace-frt
kubectl --namespace=k8s-namespace-frt get all  // make sure all the resources were removed.
I noticed everything was deleted except the running pod.
so delete the namespace to delete the pod.
kubectl delete namespace k8s-namespace-frt


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