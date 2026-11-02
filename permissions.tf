# Per-channel and per-category permission overrides, on top of the server-wide
# role permissions in roles.tf and server.tf. Anything not listed in a data block
# is left at Discord's default (inherit). Admins bypass all of these.

# ============================================================== #rules (read-only)

data "discord_permission" "ow_rules_everyone" {
  add_reactions             = "deny"
  attach_files              = "deny"
  bypass_slowmode           = "deny"
  create_instant_invite     = "deny"
  create_private_threads    = "deny"
  create_public_threads     = "deny"
  embed_links               = "deny"
  manage_channels           = "deny"
  manage_messages           = "deny"
  manage_roles              = "deny"
  manage_threads            = "deny"
  manage_webhooks           = "deny"
  mention_everyone          = "deny"
  pin_messages              = "deny"
  read_message_history      = "allow"
  send_messages             = "deny"
  send_polls                = "deny"
  send_thread_messages      = "deny"
  send_tts_messages         = "deny"
  send_voice_messages       = "deny"
  start_embedded_activities = "deny"
  use_application_commands  = "deny"
  use_external_apps         = "deny"
  use_external_emojis       = "deny"
  use_external_stickers     = "deny"
  view_channel              = "allow"
}

resource "discord_channel_permission" "rules_everyone" {
  channel_id   = discord_text_channel.rules.id
  type         = "role"
  overwrite_id = var.server_id
  allow        = data.discord_permission.ow_rules_everyone.allow_bits
  deny         = data.discord_permission.ow_rules_everyone.deny_bits
}

data "discord_permission" "ow_rules_mod" {
  manage_channels = "allow"
  manage_roles    = "allow"
}

resource "discord_channel_permission" "rules_mod" {
  channel_id   = discord_text_channel.rules.id
  type         = "role"
  overwrite_id = discord_role.mod.id
  allow        = data.discord_permission.ow_rules_mod.allow_bits
}

# ============================================================== #announcements (read-only)

data "discord_permission" "ow_announcements_everyone" {
  send_messages = "deny"
}

resource "discord_channel_permission" "announcements_everyone" {
  channel_id   = discord_news_channel.announcements.id
  type         = "role"
  overwrite_id = var.server_id
  deny         = data.discord_permission.ow_announcements_everyone.deny_bits
}

# Organizers post here: without this, only admins could.
data "discord_permission" "ow_organizer_posts" {
  send_messages = "allow"
}

resource "discord_channel_permission" "announcements_mod" {
  channel_id   = discord_news_channel.announcements.id
  type         = "role"
  overwrite_id = discord_role.mod.id
  allow        = data.discord_permission.ow_organizer_posts.allow_bits
}

# ============================================================== #jam-schedule (read-only)

data "discord_permission" "ow_read_only_everyone" {
  send_messages = "deny"
}

resource "discord_channel_permission" "jam_schedule_everyone" {
  channel_id   = discord_text_channel.jam_schedule.id
  type         = "role"
  overwrite_id = var.server_id
  deny         = data.discord_permission.ow_read_only_everyone.deny_bits
}

resource "discord_channel_permission" "jam_schedule_mod" {
  channel_id   = discord_text_channel.jam_schedule.id
  type         = "role"
  overwrite_id = discord_role.mod.id
  allow        = data.discord_permission.ow_organizer_posts.allow_bits
}

# ============================================================== Organizers (private)

data "discord_permission" "ow_private_everyone" {
  view_channel = "deny"
}

data "discord_permission" "ow_private_mod" {
  view_channel = "allow"
}

# The category: #event-planning and #mod-log copy these.
resource "discord_channel_permission" "organizers_everyone" {
  channel_id   = discord_category_channel.organizers.id
  type         = "role"
  overwrite_id = var.server_id
  deny         = data.discord_permission.ow_private_everyone.deny_bits
}

resource "discord_channel_permission" "organizers_mod" {
  channel_id   = discord_category_channel.organizers.id
  type         = "role"
  overwrite_id = discord_role.mod.id
  allow        = data.discord_permission.ow_private_mod.allow_bits
}

# #mod-chat keeps its own copy of the same two rules.
resource "discord_channel_permission" "mod_chat_everyone" {
  channel_id   = discord_text_channel.mod_chat.id
  type         = "role"
  overwrite_id = var.server_id
  deny         = data.discord_permission.ow_private_everyone.deny_bits
}

resource "discord_channel_permission" "mod_chat_mod" {
  channel_id   = discord_text_channel.mod_chat.id
  type         = "role"
  overwrite_id = discord_role.mod.id
  allow        = data.discord_permission.ow_private_mod.allow_bits
}
