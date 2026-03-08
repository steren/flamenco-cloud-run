# flamenco-cloud-run
Run Flamenco render farm on Cloud Run

> **⚠️ WARNING**: The Terraform configuration, Dockerfiles, and Flamenco configuration in this repository have **NOT BEEN TESTED**. They are meant as a starting block for deploying Flamenco to Google Cloud Run and will require manual validation and adjustments.

## Overview

This repository contains the infrastructure as code, Dockerfiles, and configuration to run the [Flamenco Render Farm](https://flamenco.blender.org/) on Google Cloud Run.

## Deployment via Terraform

To deploy the Flamenco render farm infrastructure using Terraform:

1.  **Install prerequisites:**
    Ensure you have the [Terraform CLI installed](https://developer.hashicorp.com/terraform/downloads) and the [Google Cloud CLI installed](https://cloud.google.com/sdk/docs/install).

2.  **Authenticate to Google Cloud:**
    ```bash
    gcloud auth application-default login
    ```

3.  **Initialize the Terraform configuration:**
    Navigate to the root directory containing `main.tf` and run:
    ```bash
    terraform init
    ```

4.  **Configure deployment variables:**
    Create a `terraform.tfvars` file or prepare to provide these variables when prompted. The necessary variables are:
    ```hcl
    project_id      = "your-desired-project-id"   # The ID for your new project
    billing_account = "YOUR_BILLING_ACCOUNT_ID"   # Alphanumeric billing ID
    # region        = "europe-west1"              # Optional, defaults to europe-west1
    ```

5.  **Review the deployment plan:**
    ```bash
    terraform plan
    ```

6.  **Apply the configuration:**
    ```bash
    terraform apply
    ```
    Type `yes` when prompted to create the GCP project, deploy the Cloud Storage bucket, provision the service account, and deploy the Cloud Run services.

## Building and Pushing container images

If you want to build the container images yourself rather than using the default ones, we have provided a single script to build and push them to dockerhub. Run this script:

```bash
./build-and-push.sh
```

*Note: By default the script pushes to `steren`. You'll need to update the `REGISTRY` variable inside `build-and-push.sh` to point to a registry you can push to, and then update the `manager_image` and `worker_image` default variables in `main.tf`.*