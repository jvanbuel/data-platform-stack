# Scaleway platform

This directory contains all the Terraform code to deploy the Scaleway platform.
The bootstrap directory configures the state bucket and the backend for Terraform.

# Getting started
- create an access key and secret key in the Scaleway console, and create the `.env` file based on the `.env.template`.
- source the `.env` file in your terminal to set the environment variables.
- make sure you build the helm dependencies if you apply the helm charts manually:
  - run `helm dependency build` for every application in the `argo/apps/...` directory.
- go to the `bootstrap` directory, run `tofu init` and `tofu apply` to create the state bucket.
- go to the `foundation` directory, run `tofu init` and `tofu apply` to create the foundational resources.
  - change the org_id based on the resourceid found in the Zitadel UI: https://zitadel.scaleway.playground.dataminded.cloud/ui/console/org
  - from here, will need to retrieve the `jwt_token` from the zitadel UI.
- go to the `apps` directory, run `tofu init` and `tofu apply` to create the applications.



