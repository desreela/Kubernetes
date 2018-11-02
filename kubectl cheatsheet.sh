# Login to Azure Subscription
az login

# Set subscription
az account set --subscription 9a4f9a33-925a-440b-84b1-7b97d2d2f06c

# Get access credentials for cluster
az aks get-credentials --name myakshyd --resource-group myakshyd

# setup auto complete
source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.

# Get cluster information
kubectl cluster-info
kubectl config current-context

# Get nodes
kubectl get nodes

# Display Resource (CPU/Memory/Storage) usage of nodes
kubectl top node 

# get shortnames for resources
kubectl api-resources

# Get pods
kubectl get pods
kubectl get pods --all-namespaces 
kubectl get pods -n kube-system

# Get a shell of running container
kubectl exec -it azure-vote-front-65978668f9-ksm9k  bash

# Describe pods
kubectl describe pod azure-vote-front-65978668f9-ksm9k 

# Get logs
kubectl logs azure-vote-front-65978668f9-ksm9k | more

# Get services
kubectl get service

#find out which pod is assigned to which node
kubectl get pods -o wide

# Scale web deployment to 5 replicas
kubectl scale --replicas=5 deployments/azure-vote-front
kubectl get pods -o wide --sort-by=.metadata.creationTimestamp
alias sortpods='kubectl get pods -o wide --sort-by=.metadata.creationTimestamp' 

#Cordon to prevent scheduling on node-0
kubectl cordon aks-nodepool1-20672909-0

# Scheduling disabled on node-0
kubectl get nodes
NAME                       STATUS                     ROLES     AGE       VERSION
aks-nodepool1-20672909-0   Ready,SchedulingDisabled   agent     24d       v1.10.7
aks-nodepool1-20672909-2   Ready                      agent     24d       v1.10.7
aks-nodepool1-20672909-3   Ready                      agent     1m        v1.10.7

# This does not affect pods which are already scheduled on node-0
sortpods

# Increase replicas
kubectl scale --replicas=8 deployments/azure-vote-front

# All new pods are allocated to node 2 or 3. Node-0 is cordoned off
sortpods

# Uncordon node 0
kubectl uncordon aks-nodepool1-20672909-0

# Scheduling enabled on node-0
kubectl get nodes

# Scale number of replicas to 12
kubectl scale --replicas=12 deployments/azure-vote-front

# Now new pods will get scheduled on node-0 as well
sortpods

# Scale down to 5 replicas
kubectl scale --replicas=5 deployments/azure-vote-front

# Drain a specific node, this will evict pods and move them to different nodes. Pods which are not part of replica set are not moved or evicted. 
kubectl drain aks-nodepool1-20672909-2 --force --delete-local-data --ignore-daemonsets

# Drain also cordons off node-2 but also evicts existing pods which are running
kubectl get nodes
NAME                       STATUS                     ROLES     AGE       VERSION
aks-nodepool1-20672909-0   Ready                      agent     24d       v1.10.7
aks-nodepool1-20672909-2   Ready,SchedulingDisabled   agent     24d       v1.10.7
aks-nodepool1-20672909-3   Ready                      agent     24m       v1.10.7

# Evicted pods are moved out from node-2
kubectl get pods -o wide

# Uncordone node-2
kubectl uncordon aks-nodepool1-20672909-2

# Report lifecycle changes of pods
kubectl get pods --watch-only

# Scale web instances on another putty window, You will notice new pods being created and they come into running state
kubectl scale --replicas=6 deployments/azure-vote-front

# Scale down to 5
kubectl scale --replicas=5 deployments/azure-vote-front

# Copy a file inside a pod
# Create a new file
 vi test.html
<html>
<head>
<title> Demo Page </title>
</head>
<h1> Demo Page</h1>
</html>

#Copy inside a specific path inside the pod
kubectl cp ./test.html azure-vote-front-65978668f9-ksm9k :/app/static/test.html

# Check presence of file
kubectl exec -it azure-vote-front-65978668f9-ksm9k  bash

# get YAML/JSON definition of a pod
kubectl get pods azure-vote-front-65978668f9-ksm9k  -o=yaml
kubectl get pods azure-vote-front-65978668f9-ksm9k  -o=json


# get name of containers in a pod and the image used
kubectl get pods azure-vote-front-65978668f9-ksm9k  -o jsonpath={.spec.containers[*].name}
kubectl get pods azure-vote-front-65978668f9-ksm9k  -o jsonpath={.spec.containers[*].image}

# Edit a running object
kubectl get deployments
kubectl edit deploy/azure-vote-front

# Scale out AKS cluster
az aks scale -g myakshyd -n myakshyd --node-count 4

# Check available Kubernetes versions
az aks get-versions -l westus --output table

# Upgrade AKS
az aks upgrade --name myakshyd --resource-group myakshyd --kubernetes-version 1.10.8