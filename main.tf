terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0" 
    }
  }
}

variable "region" {
  description = "The GCP region to deploy resources to"
  type        = string
  default     = "europe-west1"
}

variable "project_id" {
  description = "The GCP Project ID to create"
  type        = string
}


variable "manager_image" {
  description = "The container image to use for Flamenco Manager"
  type        = string
  default     = "steren/flamenco-manager:latest"
}

variable "worker_image" {
  description = "The container image to use for Flamenco Worker"
  type        = string
  default     = "steren/flamenco-worker:latest"
}


# 0. Enable APIs
resource "google_project_service" "run_api" {
  project = var.project_id
  service = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "storage_api" {
  project = var.project_id
  service = "storage.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam_api" {
  project = var.project_id
  service = "iam.googleapis.com"
  disable_on_destroy = false
}

# 1. Service Account
resource "google_service_account" "flamenco_sa" {
  project      = var.project_id
  account_id   = "flamenco-runner"
  display_name = "Flamenco Cloud Run Service Account"
  description  = "Service account used by Flamenco Manager and Worker to access GCS"
  depends_on   = [google_project_service.iam_api]
}
# 1. Cloud Storage Bucket
resource "google_storage_bucket" "flamenco_storage" {
  project       = var.project_id
  name          = "flamenco-shared-bucket" # Must be globally unique
  location      = var.region

  force_destroy = true

  uniform_bucket_level_access = true

  depends_on = [google_project_service.storage_api]
}

# Grant the Service Account objectAdmin access to the Bucket
resource "google_storage_bucket_iam_member" "flamenco_sa_storage_binding" {
  bucket = google_storage_bucket.flamenco_storage.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.flamenco_sa.email}"
}

# Upload the Flamenco Manager Configuration to GCS
resource "google_storage_bucket_object" "manager_config" {
  name   = "config/flamenco-manager.yaml"
  source = "config/flamenco-manager.yaml"
  bucket = google_storage_bucket.flamenco_storage.name
}

# Upload the Flamenco Worker Configuration to GCS
resource "google_storage_bucket_object" "worker_config" {
  name   = "config/flamenco-worker.yaml"
  source = "config/flamenco-worker.yaml"
  bucket = google_storage_bucket.flamenco_storage.name
}


# 2. Cloud Run Service (Autoscales from 0 to 1)
resource "google_cloud_run_v2_service" "flamenco_manager" {
  project  = var.project_id
  name     = "flamenco-manager"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  depends_on = [google_project_service.run_api]

  template {
    service_account = google_service_account.flamenco_sa.email

    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }

    containers {
      image = var.manager_image
      working_dir = "/mnt/shared-bucket/config"

      volume_mounts {
        name       = "gcs-volume"
        mount_path = "/mnt/shared-bucket"
      }
    }

    volumes {
      name = "gcs-volume"
      gcs {
        bucket    = google_storage_bucket.flamenco_storage.name
        read_only = false
      }
    }
  }
}

# 3. Cloud Run Worker Pool
resource "google_cloud_run_v2_worker_pool" "flamenco_worker" {
  project      = var.project_id
  name         = "flamenco-worker-pool"
  location     = var.region
  launch_stage = "BETA"
  depends_on   = [google_project_service.run_api]

  template {
    service_account = google_service_account.flamenco_sa.email

    containers {
      image = var.worker_image
      working_dir = "/mnt/shared-bucket/config"
      
      volume_mounts {
        name       = "gcs-volume"
        mount_path = "/mnt/shared-bucket"
      }
    }

    volumes {
      name = "gcs-volume"
      gcs {
        bucket    = google_storage_bucket.flamenco_storage.name
        read_only = false
      }
    }
  }

  scaling {
    manual_instance_count = 1
  }
}
