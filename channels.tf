# The whole server layout, top to bottom, exactly as it appears in Discord.
#
# To add a channel:     add a line where it should appear.
# To remove a channel:  delete its line.
# To reorder:           move lines (or whole categories) up or down.
# Positions are worked out from the order here; never set them by hand.
#
# Each channel line has:
#   key    unique ID used by Terraform. The Discord name is the key with "_" -> "-"
#          (set name = "..." to override). Changing a key recreates the channel, so
#          to rename a channel, set name instead.
#   type   "text" (default), "news" (announcement channel), or "forum".
#   topic  shown at the top of the channel.
#   sync   true (default) = copy the category's permissions. Set false for channels
#          with their own rules in permissions.tf.

locals {
  poses_topic_suffix = "Poses you want to try, not jam photos (those go in Photos). Credit your source; reply in a thread."

  layout = [
    { key = "start_here", name = "Start Here", channels = [
      # read-only
      { key = "rules", topic = "Code of conduct and content rules. Read before posting.", sync = false },
      # read-only
      { key = "announcements", type = "news", topic = "Server news and official events from the organizers.", sync = false },
      { key = "introductions", topic = "Say hi: your name, how long you've done acro, and whether you base, fly, or both." },
      { key = "general", topic = "Acro chat. Non-acro topics go in Off the Mat." },
      { key = "suggestions", type = "forum", topic = "One post per idea for the server or events. React to vote." },
    ] },

    { key = "events", name = "Events", channels = [
      # read-only
      { key = "jam_schedule", topic = "Recurring jam times, locations, and changes.", sync = false },
      { key = "acro_classes", topic = "Acroyoga classes and workshops." },
      { key = "other_classes", topic = "Classes and workshops for yoga." },
      { key = "pop_ups", type = "forum", topic = "Unscheduled jams anyone can post. One post per jam, with date, time, and place in the title." },
      { key = "fieldtrips", type = "forum", topic = "Plan trips to acroyoga events outside of San Antonio here." },
    ] },

    # Discord names are just the location (#the-pearl); the keys keep a photos_ prefix
    # so they stay unique and the existing channels are renamed, not recreated.
    { key = "photos", name = "Photos", channels = [
      for p in [
        ["the_pearl", "Photos from jams at The Pearl."],
        ["cirque_aria", "Photos from jams and classes at Cirque Aria."],
        ["the_district", "Photos from jams at The District bouldering gym."],
        ["austin", "Photos from jams and workshops in Austin."],
        ["other", "Photos from events in other places."],
      ] : { key = "photos_${p[0]}", name = replace(p[0], "_", "-"), topic = "${p[1]} Poses you want to try go in 🎯 Poses." }
    ] },

    { key = "poses", name = "🎯 Poses", channels = [
      for p in [
        ["l_basing", "L-basing: the base lies on their back, legs up in an L."],
        ["standing", "Standing acro: the base is on their feet."],
        ["dance_lifts", "Lifts from partner dance."],
        ["dynamic", "Everything dynamic: whips, pops, banquine, etc."],
        ["trios", "Three-person poses."],
        ["groups", "Poses with four or more people."],
        ["therapeutics", "Relaxing inversions and stretches for the flyer."],
        ["thai_massage", "Thai massage techniques."],
      ] : { key = p[0], topic = "${p[1]} ${local.poses_topic_suffix}" }
    ] },

    { key = "off_the_mat", name = "Off the Mat", channels = [
      { key = "handstands", topic = "Handstand/inversion techniques and progressions." },
      { key = "climbing", topic = "Rock climbing and bouldering." },
      { key = "dance", topic = "Country, Latin, Ecstatic, and other dance." },
      { key = "yoga", topic = "Yoga and flexibility." },
      { key = "misc", topic = "Other hobbies members share." },
      { key = "promo_and_marketplace", topic = "Self-promotion, classes, and gear for sale." },
    ] },

    { key = "collabs", name = "Collabs", channels = [
      { key = "fitness_collabs", topic = "Planning for joint events with gyms and other fitness groups." },
    ] },

    # Private: only admin and mods can see it (see permissions.tf).
    { key = "organizers", name = "Organizers", channels = [
      # has its own copy of the private rules
      { key = "mod_chat", topic = "Moderation discussion.", sync = false },
      { key = "event_planning", topic = "Planning jams and events." },
      { key = "mod_log", topic = "Log from a moderation bot, once one is added." },
    ] },
  ]

  # ---------------------------------------------------------------- derived
  # Nothing below needs editing: it turns the layout into numbered maps.

  categories = { for i, c in local.layout : c.key => { name = c.name, position = i } }

  channel_list = flatten([
    for c in local.layout : [
      for ch in c.channels : merge(
        { type = "text", sync = true, topic = null, name = replace(ch.key, "_", "-") },
        ch,
        { category = c.key },
      )
    ]
  ])

  # Channels are numbered across the whole server in display order, so Discord
  # sorts them exactly as listed. A duplicate key is an error here.
  channels = { for i, ch in local.channel_list : ch.key => merge(ch, { position = i }) }
}

# ---------------------------------------------------------------- resources

resource "discord_category_channel" "category" {
  for_each = local.categories

  server_id = var.server_id
  name      = each.value.name
  position  = each.value.position
}

resource "discord_text_channel" "text" {
  for_each = { for k, ch in local.channels : k => ch if ch.type == "text" }

  server_id                = var.server_id
  name                     = each.value.name
  category                 = discord_category_channel.category[each.value.category].id
  position                 = each.value.position
  sync_perms_with_category = each.value.sync
  topic                    = each.value.topic

  # New channels copy their category's permissions when created, so the private
  # Organizers category must be locked down first.
  depends_on = [
    discord_channel_permission.organizers_everyone,
    discord_channel_permission.organizers_mod,
  ]
}

resource "discord_news_channel" "news" {
  for_each = { for k, ch in local.channels : k => ch if ch.type == "news" }

  server_id                = var.server_id
  name                     = each.value.name
  category                 = discord_category_channel.category[each.value.category].id
  position                 = each.value.position
  sync_perms_with_category = each.value.sync
  topic                    = each.value.topic

  depends_on = [
    discord_channel_permission.organizers_everyone,
    discord_channel_permission.organizers_mod,
  ]
}

resource "discord_forum_channel" "forum" {
  for_each = { for k, ch in local.channels : k => ch if ch.type == "forum" }

  server_id                = var.server_id
  name                     = each.value.name
  category                 = discord_category_channel.category[each.value.category].id
  position                 = each.value.position
  sync_perms_with_category = each.value.sync
  topic                    = each.value.topic

  depends_on = [
    discord_channel_permission.organizers_everyone,
    discord_channel_permission.organizers_mod,
  ]
}
