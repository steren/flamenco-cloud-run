# Run Flamenco render farm on Cloud Run

> **⚠️ WARNING**: The Terraform configuration, Dockerfiles, and Flamenco configuration in this repository have **NOT BEEN TESTED**. They are meant as a starting block for deploying Flamenco to Google Cloud Run and will require manual validation and adjustments.

This repository contains the infrastructure as code, Dockerfiles, and configuration to run the [Flamenco Render Farm](https://flamenco.blender.org/) on Google Cloud Run.

## Deployment via Terraform

To deploy the Flamenco render farm infrastructure using Terraform:

1.  **Install prerequisites:**
    Ensure you have the [Terraform CLI installed](https://developer.hashicorp.com/terraform/downloads) and the [Google Cloud CLI installed](https://cloud.google.com/sdk/docs/install).

2.  **Create or use an existing GCP project:**
    Terraform expects an existing Google Cloud project. If you don't already have one, you can create it using the `gcloud` CLI.
    
    <details>
    <summary><b>Click here for step-by-step instructions to create a project via CLI</b></summary>
    
    **2.1 Authenticate to Google Cloud:**
    ```bash
    gcloud auth application-default login
    ```
    
    **2.2 Create a Google Cloud Project:**
    Replace `your-desired-project-id` with a globally unique ID:
    ```bash
    gcloud projects create your-desired-project-id --name="Flamenco Render Farm"
    ```
    
    **2.3 Link the Project to a Billing Account:**
    First, find your Billing Account ID:
    ```bash
    gcloud billing accounts list
    ```
    Then, link your new project to that Billing Account ID:
    ```bash
    gcloud billing projects link your-desired-project-id --billing-account=YOUR_BILLING_ACCOUNT_ID
    ```
    
    **2.4 Enable the required APIs:**
    Terraform needs certain Google Cloud APIs enabled to deploy Cloud Run and Cloud Storage. Run the following command:
    ```bash
    gcloud services enable run.googleapis.com storage-component.googleapis.com iam.googleapis.com --project=your-desired-project-id
    ```
    </details>

3.  **Initialize the Terraform configuration:**
    Navigate to the root directory containing `main.tf` and run:
    ```bash
    terraform init
    ```

4.  **Configure deployment variables:**
    Create a `terraform.tfvars` file or prepare to provide these variables when prompted. The necessary variables are:
    ```hcl
    project_id      = "your-desired-project-id"   # The ID of the project you just created
    # region        = "europe-west1"              # Optional, defaults to europe-west1
    # manager_image = "steren/flamenco-manager:latest" # Optional, custom manager image
    # worker_image  = "steren/flamenco-worker:latest"  # Optional, custom worker image
    ```

5.  **Review the deployment plan:**
    ```bash
    terraform plan
    ```

6.  **Apply the configuration:**
    ```bash
    terraform apply
    ```
    Type `yes` when prompted to deploy the Cloud Storage bucket, provision the service account, and deploy the Cloud Run services inside your project.

## Building and Pushing container images

If you want to build the container images yourself rather than using the default ones, we have provided a single script to build and push them to dockerhub. Run this script:

```bash
./build-and-push.sh
```

*Note: By default the script pushes to `steren`. You'll need to update the `REGISTRY` variable inside `build-and-push.sh` to point to a registry you can push to, and then update the `manager_image` and `worker_image` default variables in `main.tf`.*