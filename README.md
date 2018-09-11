# tf-aws-eks
This Terraform template deploy an high availability Amazon Web Services EKS cluster

# Configure AWS environment 
```bash
export AWS_ACCESS_KEY_ID="anaccesskey"

export AWS_SECRET_ACCESS_KEY="asecretkey"

export AWS_DEFAULT_REGION="<us-west-2 | us-east-1 | eu-west-1>"
```

# Inizialise Terraform
```bash
terraform init
```
Configure variables

# Run Terraform
```bash
terraform plan -var-file=eks.tfvars -out=out.tfplan

terraform apply out.tfplan
```

# Connect to EKS
Install Kubernetes CLI: kubectl and aws-iam-authenticator for Amazon EKS:
https://docs.aws.amazon.com/eks/latest/userguide/configure-kubectl.html

Create a file named "config" on your home directory and copy the content of Terraform output variable "kubeconfig".
Then:
```bash
export KUBECONFIG=$HOME/config
kubectl get svc
```

# Add node
Ass documented at this time, 2018-09-11, the EKS service does not provide a cluster-level API parameter or resource to automatically configure the underlying Kubernetes cluster to allow worker nodes to join the cluster via AWS IAM role authentication.
You have to manually enable worker nodes to join your cluster through Kuberneter config maps: 
https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html

Note that output variable config-map-aws-auth, in node.tf, generate the config map.