# CG for Day 2 (day) https://app.k8s.chaosgenius.io



## What is a Day 2 operations?


 Imagine you're moving into a house. If Day 1 operations are moving into the house (installation), Day 2 operations are the "housekeeping" stage of a software's life cycle. The care and feeding of the software, maintaining the overall stability and health of your software in production.


## Problems Getting to Day 2 (All tackled)

- [X] Bringing up Production grade infra
- [X] [Easy path to Install/Upgrade](#installing-or-upgrading-application) ( https://app.k8s.chaosgenius.io )
- [X] Autoscaling for anomaly/DD workers, will add more workers incase there are wating anomaly/dd tasks in queue (POC here : https://github.com/chaos-genius/celery-worker-autoscale )
- [X] Autoscaling k8s cluster by adding more ec2 instance, if current servers are fully occupied and cannot accomodate workers required for picking up pending tasks 
- [X] Observability with Grafana: resource utilization and log aggregation for running pods using https://grafana.k8s.chaosgenius.io/


# Bringng up Infra 
- [X] storing cloud provider acc credentials to environment variable
- [X] `terraform apply` # Infrastructure as code(IaC) 

# Installing or Upgrading application

- [X] `helm  upgrade --install my-chaosgenius chaosgenius --version=0.6.0` # Installs 0.6.0 version of `chaogenius` if not already installed else upgrades the existing installation(a.k.a "release" in Helm terminology)  named "my-chaosgenius".

# TODOs

- [ ] k8s cluster provisioning for non-aws cloud vendors
- [ ] Exploration of other trigger strategy for scaling workers, currently we scale if #tasks waiting in queue beyond a certain number for more than a certain duration
- [ ] Cluster autoscaler take a minute or 2 to add more nodes incase current worker nodes are occupied and there are dd/anomaly workers pending to be scheduled, we can look into Karpenter (https://karpenter.sh/, https://towardsdev.com/karpenter-vs-cluster-autoscaler-dd877b91629b) this is pretty new and was released few months back
- [ ] setting up appropriate Pod resource limits for better utilisation
- [ ] currently if persistent volume binds to addtional nodes the cluster doesnot scale down back to 0 ( this should be a fairly simple fix )
