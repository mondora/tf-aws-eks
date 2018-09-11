resource "aws_iam_role" "mondoraeks-master" {
  name = "${var.service_name}-${var.location}-master-policy"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "mondoraeks-master-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.mondoraeks-master.name}"
}

resource "aws_iam_role_policy_attachment" "mondoraeks-master-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.mondoraeks-master.name}"
}

# Worker Node

resource "aws_iam_role" "mondoraeks-node" {
  name = "${var.service_name}-${var.location}-node-policy"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "mondoraeks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.mondoraeks-node.name}"
}

resource "aws_iam_role_policy_attachment" "mondoraeks-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.mondoraeks-node.name}"
}

resource "aws_iam_role_policy_attachment" "mondoraeks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.mondoraeks-node.name}"
}

resource "aws_iam_instance_profile" "mondoraeks-node" {
  name = "${var.service_name}-${var.location}-node-policy"
  role = "${aws_iam_role.mondoraeks-node.name}"
}