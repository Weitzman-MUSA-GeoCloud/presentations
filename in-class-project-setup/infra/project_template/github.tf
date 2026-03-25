variable "github_repo_name" {}

locals {
  team_members_usernames = [for member in var.team_members : member.github_username]
}

resource "github_repository" "project" {
  name         = var.github_repo_name
  fork         = true
  source_owner = "Weitzman-MUSA-GeoCloud"
  source_repo  = "cama-template"
  description  = "CAMA project repository for ${var.project_name}"
  visibility   = "public"
  has_issues   = true
  has_projects = true

  lifecycle {
    ignore_changes = [
      fork,
      source_owner,
      source_repo,
    ]
  }
}

resource "github_team" "project" {
  name        = var.github_repo_name
  description = "CAMA project team for ${var.project_name}"
  privacy     = "closed"
}

resource "github_team_repository" "project" {
  team_id    = github_team.project.id
  repository = github_repository.project.name
  permission = "maintain"
}

resource "github_team_membership" "project" {
  for_each = toset(local.team_members_usernames)

  team_id  = github_team.project.id
  username = each.value
}

resource "github_issue_label" "front_end" {
  repository = github_repository.project.name
  name       = "Front-end"
  color      = "1D76DB"
}
resource "github_issue_label" "analysis" {
  repository = github_repository.project.name
  name       = "Analysis"
  color      = "0E8A16"
}
resource "github_issue_label" "scripting" {
  repository = github_repository.project.name
  name       = "Scripting"
  color      = "D93F0B"
}
resource "github_issue_label" "data_science" {
  repository = github_repository.project.name
  name       = "Data Science"
  color      = "5319E7"
}