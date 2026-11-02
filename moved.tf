# Renames inside Terraform only. They tell Terraform that existing channels now
# live at new addresses in the code, so it updates them in place instead of
# deleting and recreating them (which would lose their messages). Nothing here
# calls Discord. Safe to delete once these changes have been deployed.

# ---- From the first layout (#moderator-only and the original categories)

moved {
  from = discord_category_channel.information
  to   = discord_category_channel.start_here
}

moved {
  from = discord_category_channel.text_channels
  to   = discord_category_channel.events
}

moved {
  from = discord_text_channel.moderator_only
  to   = discord_text_channel.mod_chat
}

moved {
  from = discord_channel_permission.moderator_only_everyone
  to   = discord_channel_permission.mod_chat_everyone
}

# ---- To the list-driven layout in channels.tf

moved {
  from = discord_category_channel.start_here
  to   = discord_category_channel.category["start_here"]
}

moved {
  from = discord_category_channel.events
  to   = discord_category_channel.category["events"]
}

moved {
  from = discord_category_channel.photos
  to   = discord_category_channel.category["photos"]
}

moved {
  from = discord_category_channel.poses
  to   = discord_category_channel.category["poses"]
}

moved {
  from = discord_category_channel.off_the_mat
  to   = discord_category_channel.category["off_the_mat"]
}

moved {
  from = discord_category_channel.collabs
  to   = discord_category_channel.category["collabs"]
}

moved {
  from = discord_category_channel.organizers
  to   = discord_category_channel.category["organizers"]
}

moved {
  from = discord_text_channel.rules
  to   = discord_text_channel.text["rules"]
}

moved {
  from = discord_news_channel.announcements
  to   = discord_news_channel.news["announcements"]
}

moved {
  from = discord_text_channel.introductions
  to   = discord_text_channel.text["introductions"]
}

moved {
  from = discord_text_channel.general
  to   = discord_text_channel.text["general"]
}

moved {
  from = discord_forum_channel.suggestions
  to   = discord_forum_channel.forum["suggestions"]
}

moved {
  from = discord_text_channel.jam_schedule
  to   = discord_text_channel.text["jam_schedule"]
}

moved {
  from = discord_forum_channel.pop_up_jams
  to   = discord_forum_channel.forum["pop_up_jams"]
}

moved {
  from = discord_forum_channel.find_a_partner
  to   = discord_forum_channel.forum["find_a_partner"]
}

moved {
  from = discord_forum_channel.austin_carpools
  to   = discord_forum_channel.forum["austin_carpools"]
}

moved {
  from = discord_text_channel.photos["pearl"]
  to   = discord_text_channel.text["photos_pearl"]
}

moved {
  from = discord_text_channel.photos["the_district"]
  to   = discord_text_channel.text["photos_the_district"]
}

moved {
  from = discord_text_channel.photos["legacy_park"]
  to   = discord_text_channel.text["photos_legacy_park"]
}

moved {
  from = discord_text_channel.photos["civic_park"]
  to   = discord_text_channel.text["photos_civic_park"]
}

moved {
  from = discord_text_channel.photos["cirque_aria"]
  to   = discord_text_channel.text["photos_cirque_aria"]
}

moved {
  from = discord_text_channel.photos["austin"]
  to   = discord_text_channel.text["photos_austin"]
}

moved {
  from = discord_text_channel.photos["other"]
  to   = discord_text_channel.text["photos_other"]
}

moved {
  from = discord_text_channel.poses["l_basing"]
  to   = discord_text_channel.text["l_basing"]
}

moved {
  from = discord_text_channel.poses["standing"]
  to   = discord_text_channel.text["standing"]
}

moved {
  from = discord_text_channel.poses["dance_lifts"]
  to   = discord_text_channel.text["dance_lifts"]
}

moved {
  from = discord_text_channel.poses["icarian"]
  to   = discord_text_channel.text["icarian"]
}

moved {
  from = discord_text_channel.poses["whips_pops"]
  to   = discord_text_channel.text["whips_pops"]
}

moved {
  from = discord_text_channel.poses["therapeutics"]
  to   = discord_text_channel.text["therapeutics"]
}

moved {
  from = discord_text_channel.poses["thai_massage"]
  to   = discord_text_channel.text["thai_massage"]
}

moved {
  from = discord_text_channel.poses["trios"]
  to   = discord_text_channel.text["trios"]
}

moved {
  from = discord_text_channel.poses["groups"]
  to   = discord_text_channel.text["groups"]
}

moved {
  from = discord_text_channel.poses["pass_the_flyer"]
  to   = discord_text_channel.text["pass_the_flyer"]
}

moved {
  from = discord_text_channel.local_events
  to   = discord_text_channel.text["local_events"]
}

moved {
  from = discord_text_channel.dance
  to   = discord_text_channel.text["dance"]
}

moved {
  from = discord_text_channel.climbing
  to   = discord_text_channel.text["climbing"]
}

moved {
  from = discord_text_channel.yoga
  to   = discord_text_channel.text["yoga"]
}

moved {
  from = discord_text_channel.hobbies_misc
  to   = discord_text_channel.text["hobbies_misc"]
}

moved {
  from = discord_text_channel.promo_and_marketplace
  to   = discord_text_channel.text["promo_and_marketplace"]
}

moved {
  from = discord_text_channel.fitness_collabs
  to   = discord_text_channel.text["fitness_collabs"]
}

moved {
  from = discord_text_channel.mod_chat
  to   = discord_text_channel.text["mod_chat"]
}

moved {
  from = discord_text_channel.event_planning
  to   = discord_text_channel.text["event_planning"]
}

moved {
  from = discord_text_channel.mod_log
  to   = discord_text_channel.text["mod_log"]
}

# ---- Renames in the pruned layout (keys changed, channels kept)

moved {
  from = discord_forum_channel.forum["pop_up_jams"]
  to   = discord_forum_channel.forum["pop_ups"]
}

moved {
  from = discord_forum_channel.forum["austin_carpools"]
  to   = discord_forum_channel.forum["fieldtrips"]
}

moved {
  from = discord_text_channel.text["photos_pearl"]
  to   = discord_text_channel.text["photos_the_pearl"]
}

moved {
  from = discord_text_channel.text["whips_pops"]
  to   = discord_text_channel.text["dynamic"]
}

moved {
  from = discord_text_channel.text["hobbies_misc"]
  to   = discord_text_channel.text["misc"]
}
