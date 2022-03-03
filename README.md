# CG for Day 2 (day) [WIP]



## What is a Day 2 operations?


What are Day 2 operations? Imagine you're moving into a house. If Day 1 operations are moving into the house (installation), Day 2 operations are the "housekeeping" stage of a software's life cycle. The care and feeding of the software, maintaining the overall stability and health of your software in production.


## Problems Getting to Day 2

- Bringing up Production grade infra
- Easy path to Install/Upgrade
- Good Observability/monitoring for applications
- Autoscaling for anomaly/DD workers (POC here : https://github.com/chaos-genius/celery-worker-autoscale )


# Bringng up Infra could look like
- storing cloud provider acc credentials to environment variable
- `terraform apply` # Infrastructure as code(IaC) 

# Installing/Upgrading application could look like 

- `helm install chaos-genius==0.4`
- `helm upgrade chaog-genius --version=0.4.1`


# Monitoring could be 
- Grafana stack (logs/metrics/traces [loki/prometheus/tempo]) precofigured with SLO dashboard for all CG conponents