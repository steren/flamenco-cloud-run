# flamenco-cloud-run
Run Flamenco render farm on Cloud Run

> **⚠️ WARNING**: The Terraform configuration, Dockerfiles, and Flamenco configuration in this repository have **NOT BEEN TESTED**. They are meant as a starting block for deploying Flamenco to Google Cloud Run and will require manual validation and adjustments.

## Overview

This repository contains infrastructure as code and containerization instructions to deploy the [Flamenco Render Farm](https://flamenco.blender.org/) over Google Cloud:

*   **`main.tf`**: A Terraform configuration that provisions a GCS bucket, an IAM service account, a Cloud Run Service (for Flamenco Manager), and a Cloud Run Worker Pool (for Flamenco Worker nodes). The service and worker pool mount the same Google Cloud Storage bucket.
*   **`manager/Dockerfile`**: A Docker container definition for Flamenco Manager.
*   **`worker/Dockerfile`**: A Docker container definition for Flamenco Worker that includes Blender.
*   **`config/`**: Directory containing the base `flamenco-manager.yaml` and `flamenco-worker.yaml` files, which are automatically uploaded to the GCS bucket during `terraform apply`.
