
# create cluster 
resource "scaleway_k8s_cluster" "this" {
  type        = var.cluster_type
  name        = var.cluster_name
  description = var.cluster_description
  version     = var.kubernetes_version
  cni         = var.cni 
  }


  # create workers nodes 
  resource "scaleway_k8s_pool" "this" {
  cluster_id = scaleway_k8s_cluster.this.id
  name       = "hello-world-scw-worker"
  node_type  = "DEV1-M"
  size       = 2
}

# kubeconfig

resource "null_resource" "kubeconfig" {
  depends_on = [scaleway_k8s_pool.this] 
  triggers = {
    host                   = scaleway_k8s_cluster.this.kubeconfig[0].host
    token                  = scaleway_k8s_cluster.this.kubeconfig[0].token
    cluster_ca_certificate = scaleway_k8s_cluster.this.kubeconfig[0].cluster_ca_certificate
  }
}

# helm provider

provider "helm" {
  kubernetes {
    host = null_resource.kubeconfig.triggers.host
    token = null_resource.kubeconfig.triggers.token
    cluster_ca_certificate = base64decode(
    null_resource.kubeconfig.triggers.cluster_ca_certificate
    )
  }
}

# create loadbalancer
resource "scaleway_lb_ip" "nginx_ip" {
  zone       = "fr-par-1"
  project_id = scaleway_k8s_cluster.this.project_id
}

# ingress controller

resource "helm_release" "nginx_ingress" {
  name      = "nginx-ingress"
  namespace = "kube-system"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"

  set {
    name = "controller.service.loadBalancerIP"
    value = scaleway_lb_ip.nginx_ip.ip_address
  }

  // enable proxy protocol to get client ip addr instead of loadbalancer one
  set {
    name = "controller.config.use-proxy-protocol"
    value = "true"
  }
  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-proxy-protocol-v2"
    value = "true"
  }

  // indicates in which zone to create the loadbalancer
  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-zone"
    value = scaleway_lb_ip.nginx_ip.zone
  }

  // enable to avoid node forwarding
  set {
    name = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

  // enable this annotation to use cert-manager
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-use-hostname"
    value = "true"
  }
}
