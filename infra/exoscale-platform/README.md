# Exoscale Platform

This directory contains the OpenTofu/Terraform configuration for the Exoscale platform.

## Bootstrap

Configure your Exoscale (api key and secret) credentials in the `.env` file (see `.env.template` for an example). Source the environment variables:
Source the environment variables:

```bash
source .env
```

This makes the exoscale credentials available to the OpenTofu/Terraform provider, as well as the SOS credentials for remote state storage.

Apply the configuration in the `bootstrap` folder to create an SOS (S3-compatible) bucket for remote state storage.

## Applying the OpenTofu/Terraform configuration

Make sure the environment variables in `.env` are set and sourced.

Now you can run `tofu plan/apply` to manage the infrastructure in the `app` folder.
