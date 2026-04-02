# GCS Buckets:
# ${project_name}-raw_data       Raw data from the sources.
# ${project_name}-prepared_data  Data prepared for external tables in BigQuery.
# ${project_name}-temp_data      Temporary data used during processing. Files stored here will be deleted after a few days.
# ${project_name}-public         Public data that can be accessed by anyone over HTTP.

variable "billing_account_id" {}
variable "organization_id" {}
variable "project_name" {}
variable "location" {}
variable "team_members" {
  type = list(map(string))
}

locals {
  team_members_emails = [for member in var.team_members : member.gcp_email]
}

resource "google_project" "project" {
  name       = var.project_name
  project_id = var.project_name
  org_id     = var.organization_id
  billing_account = var.billing_account_id
}

resource "google_project_service" "bigquery" {
  project = google_project.project.project_id
  service = "bigquery.googleapis.com"
}

resource "google_project_service" "storage" {
  project = google_project.project.project_id
  service = "storage.googleapis.com"
}

resource "google_project_service" "cloudfunctions" {
  project = google_project.project.project_id
  service = "cloudfunctions.googleapis.com"
}

resource "google_project_service" "cloudrun" {
  project = google_project.project.project_id
  service = "run.googleapis.com"
}

resource "google_project_service" "cloudbuild" {
  project = google_project.project.project_id
  service = "cloudbuild.googleapis.com"
}

resource "google_project_service" "artifactregistry" {
  project = google_project.project.project_id
  service = "artifactregistry.googleapis.com"
}

resource "google_project_service" "workflows" {
  project = google_project.project.project_id
  service = "workflows.googleapis.com"
}

resource "google_project_service" "iam" {
  project = google_project.project.project_id
  service = "iam.googleapis.com"
}

resource "google_storage_bucket" "raw_data" {
  project                     = google_project.project.project_id
  name                        = format("%s-raw_data", google_project.project.project_id)
  location                    = var.location
  uniform_bucket_level_access = true

  autoclass {
    enabled                = true
    terminal_storage_class = "ARCHIVE"
  }

  depends_on = [
    google_project_service.storage
  ]
}

resource "google_storage_bucket" "prepared_data" {
  project                     = google_project.project.project_id
  name                        = format("%s-prepared_data", google_project.project.project_id)
  location                    = var.location
  uniform_bucket_level_access = true

  autoclass {
    enabled                = true
    terminal_storage_class = "ARCHIVE"
  }

  depends_on = [
    google_project_service.storage
  ]
}

resource "google_storage_bucket" "temp_data" {
  project                     = google_project.project.project_id
  name                        = format("%s-temp_data", google_project.project.project_id)
  location                    = var.location
  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 7
    }

    action {
      type = "Delete"
    }
  }

  depends_on = [
    google_project_service.storage
  ]
}

resource "google_storage_bucket" "public" {
  project                     = google_project.project.project_id
  name                        = format("%s-public", google_project.project.project_id)
  location                    = var.location
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  cors {
    origin          = ["*"]
    method          = ["GET", "POST", "PUT", "OPTIONS", "HEAD", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }

  depends_on = [
    google_project_service.storage
  ]
}

resource "google_storage_bucket_iam_member" "public_viewer" {
  bucket = google_storage_bucket.public.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"

  depends_on = [
    google_storage_bucket.public
  ]
}

# BigQuery Datasets:
# source   External tables backed by prepared source data in Cloud Storage.
# core     Data that is ready to be used for analysis. For the most part, the tables here are just copies of the external tables.
# derived  Data that has been derived from core data. Outputs from analyses or models go here.

resource "google_bigquery_dataset" "source" {
  project    = google_project.project.project_id
  dataset_id = "source"
  location   = var.location

  depends_on = [
    google_project_service.bigquery
  ]
}

resource "google_bigquery_dataset" "core" {
  project    = google_project.project.project_id
  dataset_id = "core"
  location   = var.location

  depends_on = [
    google_project_service.bigquery
  ]
}

resource "google_bigquery_dataset" "derived" {
  project    = google_project.project.project_id
  dataset_id = "derived"
  location   = var.location

  depends_on = [
    google_project_service.bigquery
  ]
}

# For cloud builds, make sure that the default compute service account has the
# necessary permissions.

resource "google_project_iam_member" "default_compute_run_builder" {
  project = google_project.project.project_id
  role    = "roles/run.builder"
  member  = "serviceAccount:${google_project.project.number}-compute@developer.gserviceaccount.com"
}

# Service Account:
# A service account named `data-pipeline-user` is used to provide necessary
# access to different GCP services. The following roles are assigned to the
# service account:
# - Storage Object Admin
# - BigQuery Job User
# - Cloud Functions Invoker
# - Cloud Run Invoker
# - Workflows Invoker

resource "google_service_account" "data_pipeline_user" {
  project      = google_project.project.project_id
  account_id   = "data-pipeline-user"
  display_name = "Data Pipeline User"

  depends_on = [
    google_project_service.iam
  ]
}

resource "google_project_iam_member" "data_pipeline_user_storage_object_admin" {
  project = google_project.project.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.data_pipeline_user.email}"
}

resource "google_project_iam_member" "data_pipeline_user_bigquery_job_user" {
  project = google_project.project.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.data_pipeline_user.email}"
}

resource "google_project_iam_member" "data_pipeline_user_bigquery_data_owner" {
  project = google_project.project.project_id
  role    = "roles/bigquery.dataOwner"
  member  = "serviceAccount:${google_service_account.data_pipeline_user.email}"
}

resource "google_project_iam_member" "data_pipeline_user_cloud_functions_invoker" {
  project = google_project.project.project_id
  role    = "roles/cloudfunctions.invoker"
  member  = "serviceAccount:${google_service_account.data_pipeline_user.email}"
}

resource "google_project_iam_member" "data_pipeline_user_cloud_run_invoker" {
  project = google_project.project.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.data_pipeline_user.email}"
}

resource "google_project_iam_member" "data_pipeline_user_run_developer" {
  project = google_project.project.project_id
  # Might be necessary for deploying Cloud Run services.
  role   = "roles/run.developer"
  member = "serviceAccount:${google_service_account.data_pipeline_user.email}"
}

resource "google_project_iam_member" "data_pipeline_user_workflows_invoker" {
  project = google_project.project.project_id
  role    = "roles/workflows.invoker"
  member  = "serviceAccount:${google_service_account.data_pipeline_user.email}"
}

# Custom Role:
# All students should be granted a `Team Member` role that is a combination of
# the permissions from the Project IAM Admin role and any other roles we want.

resource "google_project_iam_custom_role" "team_member" {
  project     = google_project.project.project_id
  role_id     = "teamMember"
  title       = "Team Member"
  description = "Combination of Project IAM Admin and any other roles"
  permissions = setsubtract(
    setunion(
      split("\n", file("${path.module}/../permissions/project_iam_admin.txt")),
      split("\n", file("${path.module}/../permissions/storage_admin.txt")),
      split("\n", file("${path.module}/../permissions/service_account_user.txt")),
      split("\n", file("${path.module}/../permissions/service_account_key_admin.txt")),
      split("\n", file("${path.module}/../permissions/service_account_token_creator.txt")),
      split("\n", file("${path.module}/../permissions/bq_data_owner.txt")),
      split("\n", file("${path.module}/../permissions/bq_job_user.txt")),
      split("\n", file("${path.module}/../permissions/run_admin.txt")),
      split("\n", file("${path.module}/../permissions/run_source_developer.txt")),
      split("\n", file("${path.module}/../permissions/cloudfunctions_developer.txt")),
      split("\n", file("${path.module}/../permissions/service_usage_consumer.txt")),
      split("\n", file("${path.module}/../permissions/workflows_admin.txt")),
      split("\n", file("${path.module}/../permissions/logging_viewer.txt")),
      split("\n", file("${path.module}/../permissions/errorreporting_user.txt")),
      split("\n", file("${path.module}/../permissions/monitoring_viewer.txt")),
    ),
    ["", "resourcemanager.projects.list"]
  )
}

resource "google_project_iam_member" "team_members" {
  for_each = toset(local.team_members_emails)

  project = google_project.project.project_id
  role    = google_project_iam_custom_role.team_member.id
  member  = "user:${each.value}"
}

resource "google_project_iam_member" "admins" {
  for_each = toset(local.team_members_emails)

  project = google_project.project.project_id
  role    = "roles/admin"
  member  = "user:${each.value}"
}

output "team_members" {
  value = local.team_members_emails
}
