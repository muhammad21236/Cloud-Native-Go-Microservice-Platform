module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "prod-vpc"
  cidr = var.vpc_cidr

  azs = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]

  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]

  enable_nat_gateway = true
  single_nat_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "production"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.15.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id

  enable_irsa = true

  eks_managed_node_groups = {
    backend = {
      desired_size = 3
      min_size     = 3
      max_size     = 10

      instance_types = ["t3.medium"]

      capacity_type = "ON_DEMAND"
    }
  }
}

resource "aws_ecr_repository" "app" {
  name                 = "go-cloud-native-api"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}
