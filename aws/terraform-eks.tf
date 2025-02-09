provider "aws" {
  region = "us-east-1"
}

resource "aws_eks_cluster" "fastify_cluster" {
  name     = "fastify-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = aws_subnet.public_subnets[*].id
  }
}

resource "aws_eks_node_group" "worker_nodes" {
  cluster_name  = aws_eks_cluster.fastify_cluster.name
  node_role_arn = aws_iam_role.node_role.arn
  subnet_ids    = aws_subnet.public_subnets[*].id
  instance_types = ["t3.medium"]
  scaling_config {
    desired_size = 3
    min_size     = 1
    max_size     = 4
  }
}

output "eks_cluster_name" {
  value = aws_eks_cluster.fastify_cluster.name
}
