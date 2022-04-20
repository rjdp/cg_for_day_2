Installs k8s version 1.22
prequisites

terraform

signup https://app.terraform.io/signup/account


create org
add multiple workspaces 
set share state globally for each workspace (Share with all workspaces in this organization)

Add variable set for aws keys (works accross workspace)
choose environment variable     
mark 2nd key as sensitive
choose "Apply to all workspaces in this org"

cd into each run 

terraform init
terraform apply

type "yes" on Do you want to perform these actions in workspace


eks module

add iam user and put the userarn in map_users.userarn  to access cluster by adding it to systems:master group of k8s cluster,  can do this for a role but we will not do it here (check commented section map_users)


brew install awscli kubectl

aws configure # use kubeadmin keys
aws eks --region us-east-1 update-kubeconfig --name production

For pod autoscaling to work (HPA)
----------------------------------

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.6.1/components.yaml