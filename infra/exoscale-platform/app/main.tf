resource "exoscale_sks_cluster" "this" {
  zone = local.zone
  name = local.platform_name

  cni = "cilium"
  exoscale_ccm = true
  exoscale_csi = true
  metrics_server = true

}

resource "exoscale_sks_nodepool" "this" {
  cluster_id         = exoscale_sks_cluster.this.id
  zone               = exoscale_sks_cluster.this.zone
  name               = "${local.platform_name}-nodepool"

  instance_type      = "standard.small"
  size               = 3
}

resource "exoscale_sks_kubeconfig" "this" {
  zone       = local.zone
  cluster_id = exoscale_sks_cluster.this.id

  user   = "kubernetes-admin"
  groups = ["system:masters"]

  ttl_seconds           = 3600
  early_renewal_seconds = 300
}

resource "local_sensitive_file" "this" {
  filename        = "kubeconfig"
  content         = exoscale_sks_kubeconfig.this.kubeconfig
  file_permission = "0600"
}