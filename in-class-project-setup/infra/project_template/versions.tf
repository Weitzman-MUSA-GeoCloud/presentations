terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}
