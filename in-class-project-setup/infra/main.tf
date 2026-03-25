locals {
  project_year = "s26"
  project_team_nums = toset([
    "team1",
    "team2",
    "team3",
    "team4",
    "team5",
    "team6",
    "team7",
  ])
}

module "team_project" {
  source             = "./project_template"
  for_each           = local.project_team_nums
  location           = "us-east4"
  project_name       = "musa5090${local.project_year}-${each.key}"
  github_repo_name   = "${local.project_year}-${each.key}-cama"
  organization_id    = null
  billing_account_id = var.billing_account_id
  team_members       = local.team_assignments[each.key]
}


locals {
  # We use OpenTofu's built-in `csvdecode` instead of an external `csvkit` inside
  # a `null_resource` because `null_resource` evaluates at apply-time, meaning
  # generated files can't be reliably read back into Terraform variables during plan-time.

  raw_assignments = csvdecode(file("${path.module}/team_assignments.csv"))

  # Filter out empty rows, like row 2 which consists of commas: ",,,"
  valid_assignments = [
    for row in local.raw_assignments : row
    if lookup(row, "Name", "") != "" && lookup(row, "Team", "") != ""
  ]

  # Get a distinct list of team numbers
  teams = distinct([for row in local.valid_assignments : row.Team])

  # Group assignments by Team into a map
  team_assignments = {
    for t in local.teams : "team${t}" => [
      for row in local.valid_assignments : {
        name            = row.Name
        gcp_email       = row["GCP Email"]
        github_username = row["GitHub Username"]
      }
      if row.Team == t
    ]
  }
}

output "team_members_team1" {
  value = module.team_project["team1"].team_members
}

output "team_members_team2" {
  value = module.team_project["team2"].team_members
}

output "team_members_team3" {
  value = module.team_project["team3"].team_members
}

output "team_members_team4" {
  value = module.team_project["team4"].team_members
}

output "team_members_team5" {
  value = module.team_project["team5"].team_members
}

output "team_members_team6" {
  value = module.team_project["team6"].team_members
}



# moved {
#   to   = module.team_project["team1"]
#   from = module.team_project["musa5090s26-team1"]
# }

# moved {
#   to   = module.team_project["team2"]
#   from = module.team_project["musa5090s26-team2"]
# }

# moved {
#   to   = module.team_project["team3"]
#   from = module.team_project["musa5090s26-team3"]
# }

# moved {
#   to   = module.team_project["team4"]
#   from = module.team_project["musa5090s26-team4"]
# }

# moved {
#   to   = module.team_project["team5"]
#   from = module.team_project["musa5090s26-team5"]
# }

# moved {
#   to   = module.team_project["team6"]
#   from = module.team_project["musa5090s26-team6"]
# }



# import {
#   for_each = local.project_names
#   to = module.team_project[each.key].google_storage_bucket.raw_data
#   id = "${each.key}/${each.key}-raw_data"
# }

# import {
#   for_each = local.project_names
#   to = module.team_project[each.key].google_storage_bucket.prepared_data
#   id = "${each.key}/${each.key}-prepared_data"
# }

# import {
#   for_each = local.project_names
#   to = module.team_project[each.key].google_storage_bucket.temp_data
#   id = "${each.key}/${each.key}-temp_data"
# }

# import {
#   for_each = local.project_names
#   to = module.team_project[each.key].google_storage_bucket.public
#   id = "${each.key}/${each.key}-public"
# }

# import {
#   for_each = local.project_names
#   to = module.team_project[each.key].google_storage_bucket_iam_member.public_viewer
#   id = "${each.key}-public roles/storage.objectViewer allUsers"
# }

# import {
#   for_each = local.project_names
#   to = module.team_project[each.key].google_bigquery_dataset.source
#   id = "${each.key}/source"
# }

# import {
#   for_each = local.project_names
#   to = module.team_project[each.key].google_bigquery_dataset.core
#   id = "${each.key}/core"
# }

# import {
#   for_each = local.project_names
#   to = module.team_project[each.key].google_bigquery_dataset.derived
#   id = "${each.key}/derived"
# }

# import {
#   for_each = local.project_names
#   to = module.team_project[each.key].google_service_account.data_pipeline_user
#   id = "projects/${each.key}/serviceAccounts/data-pipeline-user@${each.key}.iam.gserviceaccount.com"
# }

# import {
#   for_each = local.project_names
#   to = module.team_project[each.key].google_project_iam_member.data_pipeline_user_storage_object_admin
#   id = "${each.key} roles/storage.objectAdmin serviceAccount:data-pipeline-user@${each.key}.iam.gserviceaccount.com"
# }

# import {
#   for_each = local.project_names
#   to = module.team_project[each.key].google_project_iam_member.data_pipeline_user_bigquery_job_user
#   id = "${each.key} roles/bigquery.jobUser serviceAccount:data-pipeline-user@${each.key}.iam.gserviceaccount.com"
# }

# import {
#   for_each = local.project_names
#   to = module.team_project[each.key].google_project_iam_member.data_pipeline_user_bigquery_data_owner
#   id = "${each.key} roles/bigquery.dataOwner serviceAccount:data-pipeline-user@${each.key}.iam.gserviceaccount.com"
# }

# import {
#   for_each = local.project_names
#   to = module.team_project[each.key].google_project_iam_member.data_pipeline_user_cloud_functions_invoker
#   id = "${each.key} roles/cloudfunctions.invoker serviceAccount:data-pipeline-user@${each.key}.iam.gserviceaccount.com"
# }

# import {
#   for_each = local.project_names
#   to = module.team_project[each.key].google_project_iam_member.data_pipeline_user_cloud_run_invoker
#   id = "${each.key} roles/run.invoker serviceAccount:data-pipeline-user@${each.key}.iam.gserviceaccount.com"
# }

# import {
#   for_each = local.project_names
#   to = module.team_project[each.key].google_project_iam_member.data_pipeline_user_run_developer
#   id = "${each.key} roles/run.developer serviceAccount:data-pipeline-user@${each.key}.iam.gserviceaccount.com"
# }

# import {
#   for_each = local.project_names
#   to = module.team_project[each.key].google_project_iam_member.data_pipeline_user_workflows_invoker
#   id = "${each.key} roles/workflows.invoker serviceAccount:data-pipeline-user@${each.key}.iam.gserviceaccount.com"
# }

# import {
#   for_each = local.project_names
#   to = module.team_project[each.key].google_project_iam_custom_role.team_member
#   id = "${each.key}/teamMember"
# }
