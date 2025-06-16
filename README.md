# Data Platform Stack

* relies on open source components such as
  * Trino
  * Airflow
  * Open Policy Agent
  * Hashicorp Vault
* runs on managed Kubernetes services from a couple of EU-based providers
  * OVH
  * Scaleway
  * UpCloud
  * Exoscale

## Deployment
* pick a provider in the infra folder
 * run terraform apply and make sure to set the active kubernetes context 
 * or alternatively, ensure you have a kubernetes cluster somewhere
* follow the readme in the bootstrap folder
* make sure all the services are running
* deploy the Airflow DAGs
