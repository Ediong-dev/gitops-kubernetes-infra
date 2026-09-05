# terraform/outputs.tf

output "instance_public_ip" {
  description = "Public IP of the K3s EC2 instance"
  value       = aws_instance.k3s_server.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the K3s EC2 instance"
  value       = aws_instance.k3s_server.public_dns
}

output "kubeconfig_path" {
  description = "Path to the downloaded kubeconfig file (after apply)"
  value       = "${path.module}/../kubeconfig"
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint (from the kubeconfig)"
  value       = "https://${aws_instance.k3s_server.public_ip}:6443"
}