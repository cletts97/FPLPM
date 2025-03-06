library(dplyr)

chips_data <- readRDS("data/raw/chips_data.rds")
events <- readRDS("data/raw/events.rds")
fixtures <- readRDS("data/raw/fixtures.rds")
game_config <- readRDS("data/raw/game_config.rds")
game_settings <- readRDS("data/raw/game_settings.rds")
phases <- readRDS("data/raw/phases.rds")
player_stats_labels <- readRDS("data/raw/player_stats_labels.rds")
player_types <- readRDS("data/raw/player_types.rds")
players <- readRDS("data/raw/players.rds")
teams <- readRDS("data/raw/teams.rds")
total_players <- readRDS("data/raw/total_players.rds")

chips_data_clean <- chips_data %>%
        select(-overrides.pick_multiplier,
                           chips_id = id,
                           start_gw = start_event, 
                           stop_gw = stop_event, 
                           number_of_chips = number, 
                           element_types_override = overrides.element_types, 
                           squad_size_rules_override = overrides.rules.squad_squadsize) %>%
        arrange(chips_id)

saveRDS(chips_data_clean, "data/processed/chips_data_clean.rds")


events_clean <- events %>%
        select(-c(overrides.pick_multiplier, overrides.element_types, released, deadline_time_game_offset, release_time),
               gw_id = id,
               top_player = top_element,
               top_player_id = top_element_info.id,
               top_player_points = top_element_info.points) %>%
        arrange(gw_id)

saveRDS(events_clean, "data/processed/events_clean.rds")


fixtures_clean <- fixtures %>%
        select(c(-provisional_start_time, minutes),
               gw_id = event,
               fixture_id = id,
               away_team = team_a,
               away_team_score = team_a_score,
               home_team = team_h,
               home_team_score = team_h_score,
               home_team_difficulty = team_h_difficulty,
               away_team_difficulty = team_a_difficulty,
               pl_fixture_id = pulse_id) %>%
        arrange(gw_id, fixture_id)

saveRDS(fixtures_clean, "data/processed/fixtures_clean.rds")


phases_clean <- phases %>%
        rename(start_gw = start_event,
               stop_gw = stop_event,
               phase_id = id) %>%
        arrange(phase_id)

saveRDS(phases_clean, "data/processed/phases_clean.rds")


player_types_clean <- player_types %>%
        select(-c(plural_name_short, squad_min_select, squad_max_select),
                  position_id = id,
                  player_count = element_count,
                  squad_min_players = squad_min_play,
                  squad_max_players = squad_max_play) %>%
        arrange(position_id)

saveRDS(player_types_clean, "data/processed/player_types_clean.rds")


players_clean <- players %>%
        filter(can_select == TRUE) %>%
        select(second_name, first_name, id, team, total_points, everything(), -c(can_transact, can_select, photo, removed, special, squad_number),
               player_code = code,
               player_type = element_type,
               exp_points_next_gw = ep_next,
               exp_points_this_gw = ep_this,
               gw_points = event_points,
               player_id = id,
               transfers_in_gw = transfers_in_event,
               transfers_out_gw = transfers_out_event,
               minutes_played = minutes,
               team_id = team) %>%
        arrange(desc(total_points), second_name)

saveRDS(players_clean, "data/processed/players_clean.rds")


teams_clean <- teams %>%
        select(id, name, position, strength, everything(), -c(team_division, unavailable),
               team_code = code,
               team_id = id,
               pl_team_id = pulse_id) %>%
        arrange(team_id)

saveRDS(teams_clean, "data/processed/teams_clean.rds")


saveRDS(game_config, "data/processed/game_config_clean.rds")
saveRDS(game_settings, "data/processed/game_settings_clean.rds")
saveRDS(player_stats_labels, "data/processed/player_stats_labels_clean.rds")
saveRDS(total_players, "data/processed/total_players_clean.rds")