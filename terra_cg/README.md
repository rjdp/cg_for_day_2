# Prerequisite:

```
aws configure # to configure aws' access_key and secret
```

Instance count, Instance type, min/max instances in ASG(autoscaling group) nodegroup, region can be changed from on of the following files : main.tf, terraform.tfvars, variables.tf


# Download all required module depndencies
```
terraform init
```

# Format terraform files

```
terraform fmt
```

# Check for config inconsistencies

```
terraform validate
```


# Save plan

```
terraform plan -out m1.plan
```


# Create eks cluster or apply plan

```
terraform apply m1.plan
```


# Automatically configure kubectl

```
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
```

# check cluster

```
kubectl cluster-info
```