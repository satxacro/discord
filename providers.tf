# The bot token is read from the DISCORD_TOKEN environment variable.
# In CI it comes from the DISCORD_TOKEN repository secret; never commit it.
provider "discord" {}
