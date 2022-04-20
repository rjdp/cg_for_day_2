Installs k8s version 1.22, with cluster autoscaler and metrics-server for Pod autoscalling
prequisites

terraform cloud signup https://app.terraform.io/signup/account
create org
add multiple workspaces (kubernetes-ops-production-10-vpc, kubernetes-ops-production-20-eks, kubernetes-ops-production-25-eks-cluster-autoscaler)
set share state globally for each workspace (Share with all workspaces in this organization)

Add variable set (from org settings) for aws keys (works accross workspace)
choose environment variable     
mark 2nd key as sensitive
choose "Apply to all workspaces in this org"

cd into each folder in aws (10-vpc, 20-eks, 25-eks-cluster-autoscaler in order)  run 

terraform init
terraform apply

type "yes" on Do you want to perform these actions in workspace

Why are we using terraform cloud?
- terraform state is best stored at central place instead of someone's local computer
- the `apply` actually happens on terraform cloud and incase of local internet stability issues , longer task will continue to progress


why are we using multiple workspaces?
- speed : running `terraform plan` against workspace with lesser items is quicker
- modularity : independent changes per workspace




eks module

add iam user and put the userarn in map_users.userarn  to access cluster by adding it to systems:master group of k8s cluster,  can do this for a role but we will not do it here (check commented section map_users)


brew install awscli kubectl

aws configure # use kubeadmin keys
aws eks --region us-east-1 update-kubeconfig --name production

For pod autoscaling to work (HPA)
----------------------------------

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.6.1/components.yaml



kubectl create namespace keda

helm repo add kedacore https://kedacore.github.io/charts
helm install keda kedacore/keda --namespace keda