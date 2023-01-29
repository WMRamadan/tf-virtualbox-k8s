# Terraform Virtualbox Kubernetes Cluster

Deployment of K8s Cluster in Virtualbox VM's

## Requirements

- Virtualbox
- Terraform

## Setup
```bash
terraform init
terraform plan
terraform apply
```

## Destroy
```bash
terraform destroy
```

## Access
```bash
ssh -i .ssh/vagrant vagrant@<ip_address>
```
