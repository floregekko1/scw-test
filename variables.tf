variable "cluster_name" {
  description = "The name for the Kubernetes cluster"
  default     = "hello-world-scw"
}

variable "cluster_type" {
  description = "The type of cluster"
  default     = "kapsule"

}

variable "cluster_description" {
  description = "A description for the Kubernetes cluster"
  default     = null
}

variable "kubernetes_version" {
  default     = "1.23.0"
  description = "The version of the Kubernetes cluster"
}

variable "cni" {
 default   = "flannel" 
}