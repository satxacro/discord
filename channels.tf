# Categories and channels, in the order they appear in Discord.
#
# position: Discord sorts by these numbers. Categories are numbered 0-6, and
# channels are numbered across the whole server in display order (not restarting
# per category), so Discord keeps them exactly as written.
#
# sync_perms_with_category: true = the channel copies its category's permissions,
# and Terraform re-copies them whenever it updates the channel. Channels with their
# own overrides in permissions.tf must be false.

# ============================================================== Categories

resource "discord_category_channel" "start_here" {
  server_id = var.server_id
  name      = "Start Here"
  position  = 0
}

resource "discord_category_channel" "events" {
  server_id = var.server_id
  name      = "Events"
  position  = 1
}

resource "discord_category_channel" "photos" {
  server_id = var.server_id
  name      = "Photos"
  position  = 2
}

resource "discord_category_channel" "poses" {
  server_id = var.server_id
  name      = "🎯 Poses"
  position  = 3
}

resource "discord_category_channel" "off_the_mat" {
  server_id = var.server_id
  name      = "Off the Mat"
  position  = 4
}

resource "discord_category_channel" "collabs" {
  server_id = var.server_id
  name      = "Collabs"
  position  = 5
}

# Private: only admin and mods can see it (see permissions.tf).
resource "discord_category_channel" "organizers" {
  server_id = var.server_id
  name      = "Organizers"
  position  = 6
}

# ============================================================== Start Here

# Read-only (see permissions.tf).
resource "discord_text_channel" "rules" {
  server_id                = var.server_id
  name                     = "rules"
  category                 = discord_category_channel.start_here.id
  position                 = 0
  sync_perms_with_category = false
  topic                    = "Code of conduct and content rules. Read before posting."
}

# Read-only (see permissions.tf).
resource "discord_news_channel" "announcements" {
  server_id                = var.server_id
  name                     = "announcements"
  category                 = discord_category_channel.start_here.id
  position                 = 1
  sync_perms_with_category = false
  topic                    = "Server news and official events from the organizers."
}

resource "discord_text_channel" "introductions" {
  server_id                = var.server_id
  name                     = "introductions"
  category                 = discord_category_channel.start_here.id
  position                 = 2
  sync_perms_with_category = true
  topic                    = "Say hi: your name, how long you've done acro, and whether you base, fly or both."
}

resource "discord_text_channel" "general" {
  server_id                = var.server_id
  name                     = "general"
  category                 = discord_category_channel.start_here.id
  position                 = 3
  sync_perms_with_category = true
  topic                    = "Acro chat. Non-acro topics go in Off the Mat."
}

resource "discord_forum_channel" "suggestions" {
  server_id                = var.server_id
  name                     = "suggestions"
  category                 = discord_category_channel.start_here.id
  position                 = 4
  sync_perms_with_category = true
  topic                    = "One post per idea for the server or events. React to vote."
}

# ============================================================== Events

# Read-only (see permissions.tf).
resource "discord_text_channel" "jam_schedule" {
  server_id                = var.server_id
  name                     = "jam-schedule"
  category                 = discord_category_channel.events.id
  position                 = 5
  sync_perms_with_category = false
  topic                    = "Recurring jam times, locations and changes. RSVP under Events."
}

resource "discord_forum_channel" "pop_up_jams" {
  server_id                = var.server_id
  name                     = "pop-up-jams"
  category                 = discord_category_channel.events.id
  position                 = 6
  sync_perms_with_category = true
  topic                    = "Unscheduled jams anyone can post. One post per jam, with date, time and place in the title."
}

resource "discord_forum_channel" "find_a_partner" {
  server_id                = var.server_id
  name                     = "find-a-partner"
  category                 = discord_category_channel.events.id
  position                 = 7
  sync_perms_with_category = true
  topic                    = "Looking for a practice partner outside regular jams, or visiting San Antonio? Post here."
}

resource "discord_forum_channel" "austin_carpools" {
  server_id                = var.server_id
  name                     = "austin-carpools"
  category                 = discord_category_channel.events.id
  position                 = 8
  sync_perms_with_category = true
  topic                    = "One post per Austin event to share rides."
}

# ============================================================== Photos
# To add a location, add a line to the list. Order here = order in Discord.

locals {
  photo_channels = [
    { key = "pearl", where = "Pearl jams" },
    { key = "the_district", where = "The District jams" },
    { key = "legacy_park", where = "Legacy Park jams" },
    { key = "civic_park", where = "Civic Park jams" },
    { key = "cirque_aria", where = "Cirque Aria sessions" },
    { key = "austin", where = "Austin events we attend" },
    { key = "other", where = "other events and places" },
  ]
  photos_first_position = 9
}

resource "discord_text_channel" "photos" {
  for_each = { for i, p in local.photo_channels : p.key => merge(p, { position = local.photos_first_position + i }) }

  server_id                = var.server_id
  name                     = "photos-${replace(each.key, "_", "-")}"
  category                 = discord_category_channel.photos.id
  position                 = each.value.position
  sync_perms_with_category = true
  topic                    = "Photos and videos from our ${each.value.where}. Poses you want to try go in 🎯 Poses."
}

# ============================================================== 🎯 Poses

locals {
  pose_channels = [
    { key = "l_basing", about = "L-basing: the base lies on their back, legs up in an L. Pairs, static." },
    { key = "standing", about = "Standing acro: the base is on their feet. Pairs, static." },
    { key = "dance_lifts", about = "Lifts from partner dance. Pairs, dynamic." },
    { key = "icarian", about = "Icarian: the base moves the flyer through flips and transitions with their feet. Pairs, dynamic." },
    { key = "whips_pops", about = "Whips and pops: the base swings or throws the flyer between positions. Pairs, dynamic." },
    { key = "therapeutics", about = "Therapeutic flying: relaxing inversions and stretches for the flyer." },
    { key = "thai_massage", about = "Thai massage techniques." },
    { key = "trios", about = "Three-person poses." },
    { key = "groups", about = "Poses with four or more people." },
    { key = "pass_the_flyer", about = "Two or more bases work with one or more flyers." },
  ]
  poses_first_position = 16
  poses_topic_suffix   = "Poses you want to try, not jam photos (those go in Photos). Credit your source; reply in a thread."
}

resource "discord_text_channel" "poses" {
  for_each = { for i, p in local.pose_channels : p.key => merge(p, { position = local.poses_first_position + i }) }

  server_id                = var.server_id
  name                     = replace(each.key, "_", "-")
  category                 = discord_category_channel.poses.id
  position                 = each.value.position
  sync_perms_with_category = true
  topic                    = "${each.value.about} ${local.poses_topic_suffix}"
}

# ============================================================== Off the Mat

resource "discord_text_channel" "local_events" {
  server_id                = var.server_id
  name                     = "local-events"
  category                 = discord_category_channel.off_the_mat.id
  position                 = 26
  sync_perms_with_category = true
  topic                    = "Non-acro events around San Antonio."
}

resource "discord_text_channel" "dance" {
  server_id                = var.server_id
  name                     = "dance"
  category                 = discord_category_channel.off_the_mat.id
  position                 = 27
  sync_perms_with_category = true
  topic                    = "Country, Latin, Ecstatic and other dance."
}

resource "discord_text_channel" "climbing" {
  server_id                = var.server_id
  name                     = "climbing"
  category                 = discord_category_channel.off_the_mat.id
  position                 = 28
  sync_perms_with_category = true
  topic                    = "Rock climbing and bouldering."
}

resource "discord_text_channel" "yoga" {
  server_id                = var.server_id
  name                     = "yoga"
  category                 = discord_category_channel.off_the_mat.id
  position                 = 29
  sync_perms_with_category = true
  topic                    = "Yoga and flexibility."
}

resource "discord_text_channel" "hobbies_misc" {
  server_id                = var.server_id
  name                     = "hobbies-misc"
  category                 = discord_category_channel.off_the_mat.id
  position                 = 30
  sync_perms_with_category = true
  topic                    = "Other hobbies members share."
}

resource "discord_text_channel" "promo_and_marketplace" {
  server_id                = var.server_id
  name                     = "promo-and-marketplace"
  category                 = discord_category_channel.off_the_mat.id
  position                 = 31
  sync_perms_with_category = true
  topic                    = "Self-promotion, classes, and gear for sale."
}

# ============================================================== 🤝 Collabs

resource "discord_text_channel" "fitness_collabs" {
  server_id                = var.server_id
  name                     = "fitness-collabs"
  category                 = discord_category_channel.collabs.id
  position                 = 32
  sync_perms_with_category = true
  topic                    = "Planning joint events with other fitness groups."
}

# ============================================================== Organizers

resource "discord_text_channel" "mod_chat" {
  server_id                = var.server_id
  name                     = "mod-chat"
  category                 = discord_category_channel.organizers.id
  position                 = 33
  sync_perms_with_category = false
  topic                    = "Moderation discussion."
}

resource "discord_text_channel" "event_planning" {
  server_id                = var.server_id
  name                     = "event-planning"
  category                 = discord_category_channel.organizers.id
  position                 = 34
  sync_perms_with_category = true
  topic                    = "Planning jams and events."

  depends_on = [
    discord_channel_permission.organizers_everyone,
    discord_channel_permission.organizers_mod,
  ]
}

resource "discord_text_channel" "mod_log" {
  server_id                = var.server_id
  name                     = "mod-log"
  category                 = discord_category_channel.organizers.id
  position                 = 35
  sync_perms_with_category = true
  topic                    = "Log from a moderation bot, once one is added."

  depends_on = [
    discord_channel_permission.organizers_everyone,
    discord_channel_permission.organizers_mod,
  ]
}
