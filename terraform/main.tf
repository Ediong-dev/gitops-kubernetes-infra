# 1. Provider configuration
provider "aws" {
  region = var.aws_region
}

# 2. Data sources for required IAM roles (These need to exist in your AWS account)
#    In production, you would create these roles, but we use data sources to keep it clean.
data "aws_iam_role" "eks_cluster_role" {
  name = "EKSClusterRole" # Pre-created role for EKS control plane
}

data "aws_iam_role" "eks_node_group_role" {
  name = "EKSNodeGroupRole" # Pre-created role for worker nodes
}

# 3. Networking: VPC and Subnets
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name                                        = "portfolio-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# Public subnets (2 for high availability)
resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "portfolio-subnet-${count.index}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
}

# Internet Gateway (allows internet access)
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "portfolio-igw"
  }
}

# Route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "portfolio-route-table"
  }
}

# Associate route table with subnets
resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Get availability zones for the region
data "aws_availability_zones" "available" {
  state = "available"
}

# 4. EKS Cluster (Kubernetes control plane)
resource "aws_eks_cluster" "portfolio" {
  name     = var.cluster_name
  role_arn = data.aws_iam_role.eks_cluster_role.arn
  version  = "1.30"

  vpc_config {
    subnet_ids = aws_subnet.public[*].id
  }

  tags = {
    Name = "portfolio-eks"
  }

  depends_on = [
    aws_route_table_association.public,
    aws_internet_gateway.main
  ]
}

# 5. EKS Node Group (worker nodes)
resource "aws_eks_node_group" "portfolio" {
  cluster_name    = aws_eks_cluster.portfolio.name
  node_group_name = "portfolio-workers"
  node_role_arn   = data.aws_iam_role.eks_node_group_role.arn
  subnet_ids      = aws_subnet.public[*].id

  scaling_config {
    desired_size = var.desired_node_count
    max_size     = 5
    min_size     = 2
  }

  instance_types = [var.node_instance_type]

  tags = {
    Name = "portfolio-node-group"
  }

  depends_on = [
    aws_eks_cluster.portfolio
  ]
}