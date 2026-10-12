# Import blocks tell Terraform to adopt things that already exist in Discord
# instead of creating duplicates. Once the first apply has succeeded you can
# delete this file (keeping it is harmless).

import {
  to = discord_role.admin
  id = "1506339049974010008:1506341171461619904"
}

import {
  to = discord_role.mod
  id = "1506339049974010008:1506362373282201630"
}

import {
  to = discord_role.mid
  id = "1506339049974010008:1506364249625067601"
}

import {
  to = discord_role.flyer
  id = "1506339049974010008:1506364836701933569"
}

import {
  to = discord_role.base
  id = "1506339049974010008:1506363479265906929"
}

import {
  to = discord_category_channel.information
  id = "1506368597063241819"
}

import {
  to = discord_category_channel.text_channels
  id = "1506339051391815961"
}

import {
  to = discord_category_channel.voice_channels
  id = "1506339051391815962"
}

import {
  to = discord_voice_channel.general
  id = "1506339052478136461"
}

import {
  to = discord_text_channel.moderator_only
  id = "1506377089756958981"
}

import {
  to = discord_text_channel.rules
  id = "1506369317405589634"
}

import {
  to = discord_news_channel.announcements
  id = "1506392543389024446"
}

import {
  to = discord_text_channel.introductions
  id = "1506368880115843152"
}

import {
  to = discord_text_channel.general_2
  id = "1506339051391815964"
}

import {
  to = discord_channel_permission.moderator_only_everyone
  id = "1506377089756958981:1506339049974010008:role"
}

import {
  to = discord_channel_permission.rules_everyone
  id = "1506369317405589634:1506339049974010008:role"
}

import {
  to = discord_channel_permission.rules_mod
  id = "1506369317405589634:1506362373282201630:role"
}

import {
  to = discord_channel_permission.announcements_everyone
  id = "1506392543389024446:1506339049974010008:role"
}

import {
  to = discord_managed_server.this
  id = "1506339049974010008"
}

import {
  to = discord_role_everyone.this
  id = "1506339049974010008"
}
