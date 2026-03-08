# flamenco-cloud-run
Run Flamenco render farm on Cloud Run

> **⚠️ WARNING**: The Terraform configuration, Dockerfiles, and Flamenco configuration in this repository have **NOT BEEN TESTED**. They are meant as a starting block for deploying Flamenco to Google Cloud Run and will require manual validation and adjustments.

## Overview

This repository contains infrastructure as code and containerization instructions to deploy the [Flamenco Render Farm](https://flamenco.blender.org/) over Google Cloud:

*   **`main.tf`**: A Terraform configuration that provisions a GCS bucket, an IAM service account, a Cloud Run Service (for Flamenco Manager), and a Cloud Run Worker Pool (for Flamenco Worker nodes). The service and worker pool mount the same Google Cloud Storage bucket.
*   **`manager/Dockerfile`**: A Docker container definition for Flamenco Manager.
*   **`worker/Dockerfile`**: A Docker container definition for Flamenco Worker that includes Blender.
*   **`config/`**: Directory containing the base `flamenco-manager.yaml` and `flamenco-worker.yaml` files, which are automatically uploaded to the GCS bucket during `terraform apply`.

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
