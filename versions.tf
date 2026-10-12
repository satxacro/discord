terraform {
  required_version = ">= 1.6.0"

  # State lives in HCP Terraform (free tier: up to 500 managed resources,
  # which is far more than a Discord server needs). The workspace must use
  # the "Local" execution mode so GitHub Actions does the actual runs and
  # HCP Terraform only stores state and handles locking. See README.md.
  cloud {
    organization = "satxacro"

    workspaces {
      name = "discord"
    }
  }

  required_providers {
    discord = {
      source  = "Lucky3028/discord"
      version = "~> 2.7"
    }
  }
}
