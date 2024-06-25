#!/bin/bash

# Define the SSH key and username to use for connecting to the EC2 instances
ssh_key=/path/to/ssh_key.pem
ssh_user=ec2-user

# Define the IP addresses or DNS names of the EC2 instances
ec2_instances=(
  "ec2-1-2-3-4.compute-1.amazonaws.com"
  "ec2-2-3-4-5.compute-1.amazonaws.com"
  "ec2-3-4-5-6.compute-1.amazonaws.com"
)

# Loop through the EC2 instances and run the `docker ps` command on each
for instance in "${ec2_instances[@]}"; do
  echo "Checking Docker processes on $instance..."
  ssh -i $ssh_key $ssh_user@$instance "docker ps"
done
