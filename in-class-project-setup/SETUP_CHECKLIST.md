Resources in GitHub and Google Cloud are going to be created automatically using the OpenTofu configuration in the [infra](infra) directory. You will need to create an _infra/.auto.tfvars_ file that contains the following variables:

```hcl
billing_account_id = "..."
```

You will also need to create a CSV file named `infra/team_assignments.csv` with the following columns:

| Name | GCP Email | GitHub Username | Team |
|------|-----------|-----------------|------|
| ...  | ...       | ...             | ...  |

Then run `tofu init` and `tofu apply` to create the resources.

## GitHub

Afterwards, in GitHub:

- [ ] Update the `sync_issues.mjs` script with the correct values for `GITHUB_OWNER`, `TERM`, and `NUM_TEAMS`.
  - [ ] Create a `.env` file with a `GITHUB_TOKEN` variable containing a personal access token with `repo` scope.
  - [ ] Run `node sync_issues.mjs` to create the issues in each team's repository.
- [ ] Create a project for each team's repository. Use a Kanban board template.
  - [ ] Update the board's **View** options to include the **Labels** and **Reviewers** fields. Be sure to click **Save view** to save your changes.
  - [ ] Add the issues to the board (should be an option to do this automatically when creating the project).

## Google Cloud

- [ ] Update the **presentations/in-class-project-setup/infra/provider.tf** file to use a new prefix for the state backend -- e.g. `prefix = "tf/state-s25"`.
<!-- - [ ] Create a new role called "Team Member" in each project. Initialize with permissions from "Editor" and "Project IAM Admin". -->
- [ ] Add a principal for each group member to the "Team Member" role in the project. You can do this through the Console GUI, or using the [`gcloud projects add-iam-policy-binding`](https://cloud.google.com/sdk/gcloud/reference/projects/add-iam-policy-binding) command.
- [ ] Create a new service account for each team. Add the "BigQuery Data Editor", "BigQuery Job User", "Cloud Run Invoker", "Storage Object Admin", and "Workflows Invoker" roles to the service account.
- [ ] Create four new buckets for each team: `musa5090s25-team1-raw_data`, `musa5090s25-team1-table_data`, `musa5090s25-team1-public`, and `musa5090s25-team1-temp`.
- [ ] Give the `temp` bucket a lifecycle rule to delete objects after 7 days.
- [ ] Allow cross-origin resource sharing on the `public` bucket.
- [ ] Upload old tiles and chart data for apex charts to the `public` bucket.
- [ ] Create new datasets in BigQuery called `source`, `core` and `derived` for each project.
- [ ] Add tables named `core.opa_properties`, `core.opa_assessments`, and `core.pwd_parcels` to the `core` dataset.