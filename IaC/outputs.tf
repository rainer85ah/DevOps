output "eks_kubeconfig" {
  description = "EKS kubeconfig file content"
  value       = module.eks.kubeconfig
  sensitive   = true
}

output "gke_kubeconfig" {
  description = "GKE kubeconfig file content"
  value       = module.gke.kubeconfig
  sensitive   = true
}

output "aks_kubeconfig" {
  description = "AKS kubeconfig file content"
  value       = module.aks.kubeconfig
  sensitive   = true
}

output "docker_swarm_manager_ip" {
  description = "Docker Swarm manager node public IP"
  value       = module.docker_swarm.manager_ip
}

output "docker_swarm_join_token" {
  description = "Docker Swarm join command"
  value       = module.docker_swarm.worker_join_cmd
  sensitive   = true
}