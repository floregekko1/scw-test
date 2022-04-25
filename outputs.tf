output "cluster" {
    value = scaleway_k8s_cluster.this.id
  
}

output "worker" {
    value = scaleway_k8s_pool.this.id
  
}

output "kubeconfig" {
    value = null_resource.kubeconfig.triggers
  
}


output "lb" {
    value = scaleway_lb_ip.nginx_ip.id
  
}

output "lp-ip" {
    value = scaleway_lb_ip.nginx_ip.ip_address
  
}

output "helm-release" {
    value = helm_release.nginx_ingress.chart
  
}