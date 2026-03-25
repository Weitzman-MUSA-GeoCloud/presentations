# Infrastructure

This directory contains the infrastructure code for the in-class project setup. The infrastructure is defined using [OpenTofu](https://opentofu.org/docs/intro/), a fork of [Terraform](https://www.terraform.io/).

## Initializing for all projects

Create an _.auto.tfvars_ file with the billing account ID:

```hcl
billing_account_id = ""
```

You will probably have to set the application default credentials:

```bash
gcloud auth application-default login --project weitzman-musa-geocloud
gcloud config set project weitzman-musa-geocloud
```

You may also have to log into `gh`:

```bash
gh auth login
```

Afterwards, to initialize the infrastructure (**Note: Be careful running `init` with `-reconfigure` as it will get rid of any existing configuration state data, if there is some**):

```bash
tofu init -reconfigure
tofu apply
```

## Updating roles/team_member permissions

Run the following:

```bash
gcloud iam roles describe roles/resourcemanager.projectIamAdmin --format json | jq -r '.includedPermissions | join("\n")' > permissions/project_iam_admin.txt

gcloud iam roles describe roles/storage.admin --format json | jq -r '.includedPermissions | join("\n")' > permissions/storage_admin.txt

gcloud iam roles describe roles/iam.serviceAccountUser --format json | jq -r '.includedPermissions | join("\n")' > permissions/service_account_user.txt

gcloud iam roles describe roles/iam.serviceAccountTokenCreator --format json | jq -r '.includedPermissions | join("\n")' > permissions/service_account_token_creator.txt

gcloud iam roles describe roles/bigquery.dataOwner --format json | jq -r '.includedPermissions | join("\n")' > permissions/bq_data_owner.txt

gcloud iam roles describe roles/run.admin --format json | jq -r '.includedPermissions | join("\n")' > permissions/run_admin.txt

# For deploying cloud run services (https://docs.cloud.google.com/run/docs/deploy-functions#required-roles)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Cloud Run Source Developer (roles/run.sourceDeveloper) on your project
# Service Usage Consumer (roles/serviceusage.serviceUsageConsumer) on your project
# Service Account User (roles/iam.serviceAccountUser) on the Cloud Run service identity

gcloud iam roles describe roles/run.sourceDeveloper --format json | jq -r '.includedPermissions | join("\n")' > permissions/run_source_developer.txt

gcloud iam roles describe roles/serviceusage.serviceUsageConsumer --format json | jq -r '.includedPermissions | join("\n")' > permissions/service_usage_consumer.txt
```