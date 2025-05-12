resource "exoscale_anti_affinity_group" "this" {
  name = "dp-sks-aag"
}

resource "exoscale_security_group" "this" {
  name = "dp-sks-sg"
}

resource "exoscale_security_group_rule" "kubelet" {
  security_group_id = exoscale_security_group.this.id
  description       = "Kubelet"
  type              = "INGRESS"
  protocol          = "TCP"
  start_port        = 10250
  end_port          = 10250
  # (between worker nodes only)
  user_security_group_id = exoscale_security_group.this.id
}

resource "exoscale_security_group_rule" "nodeport_tcp" {
  security_group_id = exoscale_security_group.this.id
  description       = "Nodeport TCP services"
  type              = "INGRESS"
  protocol          = "TCP"
  start_port        = 30000
  end_port          = 32767
  # (public)
  cidr = "0.0.0.0/0"
}

resource "exoscale_security_group_rule" "nodeport_udp" {
  security_group_id = exoscale_security_group.this.id
  description       = "Nodeport UDP services"
  type              = "INGRESS"
  protocol          = "UDP"
  start_port        = 30000
  end_port          = 32767
  # (public)
  cidr = "0.0.0.0/0"
}

resource "exoscale_sks_cluster" "this" {
  zone = local.zone
  name = local.platform_name

  cni            = "cilium"
  exoscale_ccm   = true
  exoscale_csi   = true
  metrics_server = true
}

resource "exoscale_sks_nodepool" "this" {
  cluster_id              = exoscale_sks_cluster.this.id
  zone                    = exoscale_sks_cluster.this.zone
  name                    = "${local.platform_name}-nodepool"
  anti_affinity_group_ids = [exoscale_anti_affinity_group.this.id]
  security_group_ids      = [exoscale_security_group.this.id]

  instance_type = "standard.small"
  size          = 3
}



resource "exoscale_sks_kubeconfig" "this" {
  zone       = local.zone
  cluster_id = exoscale_sks_cluster.this.id

  user   = "kubernetes-admin"
  groups = ["system:masters"]

  ttl_seconds           = 3600
  early_renewal_seconds = 300
}

resource "local_sensitive_file" "kubeconfig" {
  filename        = "exoscale.kubeconfig"
  content         = exoscale_sks_kubeconfig.this.kubeconfig
  file_permission = "0600"
}