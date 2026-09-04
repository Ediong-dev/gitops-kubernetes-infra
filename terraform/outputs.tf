output "cluster_endpoint" {
  description = "The endpoint for your EKS cluster"
  value       = aws_eks_cluster.portfolio.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the cluster"
  value       = aws_eks_cluster.portfolio.vpc_config[0].cluster_security_group_id
}

output "node_group_status" {
  description = "Status of the node group"
  value       = aws_eks_node_group.portfolio.status
}