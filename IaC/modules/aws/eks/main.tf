# AWS EKS minimal cluster module (best-practice defaults)
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "${var.environment}-eks-vpc" }
}

resource "aws_subnet" "this" {
  count = 2
  vpc_id = aws_vpc.this.id
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = { Name = "${var.environment}-eks-subnet-${count.index}" }
}

data "aws_availability_zones" "available" {}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"
  cluster_name    = "${var.environment}-eks"
  cluster_version = "1.29"
  subnets         = aws_subnet.this[*].id
  vpc_id          = aws_vpc.this.id
  # node_group_defaults and node_groups for managed nodes
  node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t3.medium"]
    }
  }
}

output "kubeconfig" {
  value = module.eks.kubeconfig
  sensitive = true
}