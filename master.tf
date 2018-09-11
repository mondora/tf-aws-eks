resource "aws_eks_cluster" "mondoraeks-master" {
  name            = "${var.service_name}-${var.location}-eks"
  role_arn        = "${aws_iam_role.mondoraeks-master.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.mondoraeks-cluster.id}"]
    subnet_ids         = ["${aws_subnet.mondoraekssubnet.*.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.mondoraeks-master-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.mondoraeks-master-AmazonEKSServicePolicy",
  ]
}

locals {
  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.mondoraeks-master.endpoint}
    certificate-authority-data: ${aws_eks_cluster.mondoraeks-master.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.service_name}-${var.location}-eks"
KUBECONFIG
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}