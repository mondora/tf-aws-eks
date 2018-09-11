# EKS API master
resource "aws_security_group" "mondoraeks-cluster" {
  name        = "${var.service_name}-${var.location}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.mondoraeksvpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.service_name}-${var.location}-policy"
  }
}

resource "aws_security_group_rule" "mondoraeks-api-https" {
  cidr_blocks       = ["${var.client_IP}"]
  description       = "Allow client to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.mondoraeks-cluster.id}"
  to_port           = 443
  type              = "ingress"
}

# Worker Node

resource "aws_security_group" "mondoraeks-node" {
  name        = "${var.service_name}-${var.location}-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${aws_vpc.mondoraeksvpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "terraform-eks-demo-node",
     "kubernetes.io/cluster/${var.service_name}", "owned",
    )
  }"
}

resource "aws_security_group_rule" "mondoraeks-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.mondoraeks-node.id}"
  source_security_group_id = "${aws_security_group.mondoraeks-node.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "mondoraeks-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.mondoraeks-node.id}"
  source_security_group_id = "${aws_security_group.mondoraeks-cluster.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "mondoraeks-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.mondoraeks-cluster.id}"
  source_security_group_id = "${aws_security_group.mondoraeks-node.id}"
  to_port                  = 443
  type                     = "ingress"
}