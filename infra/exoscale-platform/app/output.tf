output "sks_cluster_endpoint" {
  value = exoscale_sks_cluster.this.endpoint
}

output "sks_connection" {
  value = format(
    "export KUBECONFIG=%s; kubectl cluster-info; kubectl get pods -A",
    local_sensitive_file.kubeconfig.filename,
  )
}


output "sos_credentials" {
  sensitive = true
  value = {
    access_key_id     = exoscale_iam_api_key.sos.key
    secret_access_key = exoscale_iam_api_key.sos.secret
  }

}