#!/bin/bash

# Get the IP addresses of the master and worker nodes
read -p "Enter the IP address of the master node: " MASTER_IP
read -p "Enter the IP address of the first worker node: " WORKER1_IP
read -p "Enter the IP address of the second worker node: " WORKER2_IP

# Initialize the cluster on the master node
TOKEN=$(ssh root@$MASTER_IP "kubeadm init --pod-network-cidr=10.244.0.0/16" | awk '/token/ {print $7}')
HASH=$(ssh root@$MASTER_IP "openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'")

# Join the worker nodes to the cluster
for node in "$WORKER1_IP" "$WORKER2_IP"; do
  ssh root@$node "kubeadm join $MASTER_IP:6443 --token $TOKEN --discovery-token-ca-cert-hash sha256:$HASH"
done

# Copy the configuration to the local machine
mkdir -p ~/.kube
scp root@$MASTER_IP:/etc/kubernetes/admin.conf ~/.kube/config