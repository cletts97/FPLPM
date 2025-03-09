library(dplyr)

## Load in raw data
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

## Clean chips_data
chips_data_clean <- chips_data %>%
        select(-overrides.pick_multiplier,
               chips_id = id,
               start_gw = start_event,
               stop_gw = stop_event,
               number_of_chips = number,
               element_types_override = overrides.element_types,
               squad_size_rules_override = overrides.rules.squad_squadsize) %>%
        mutate(
                across(
                        c(
                                chips_id,
                                number_of_chips,
                                start_gw,
                                stop_gw,
                                squad_size_rules_override
                        ),
                        as.integer
                ),
                across(c(name, chip_type), as.factor),
                across(c(element_types_override), as.list)
               ) %>%
        arrange(chips_id)

saveRDS(chips_data_clean, "data/processed/chips_data_clean.rds")


## Clean events
events_clean <- events %>%
        select(-c(overrides.pick_multiplier, overrides.element_types, released, deadline_time_game_offset, release_time),
               gw_id = id,
               top_player = top_element,
               top_player_id = top_element_info.id,
               top_player_points = top_element_info.points) %>%
        mutate(
                across(
                        c(
                                gw_id,
                                average_entry_score,
                                highest_scoring_entry,
                                deadline_time_epoch,
                                highest_score,
                                ranked_count,
                                most_selected,
                                most_transferred_in,
                                top_player,
                                transfers_made,
                                most_captained,
                                most_vice_captained,
                                top_player_id,
                                top_player_points
                        ), 
                        as.integer
                ),
                across(
                        c(
                                finished,
                                data_checked,
                                is_previous,
                                is_current,
                                is_next,
                                cup_leagues_created,
                                h2h_ko_matches_created,
                                can_enter,
                                can_manage
                        ),
                        as.logical
                ),
                across(name, as.character),
                across(deadline_time, ~ as.POSIXct(., format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")),
                across(chip_plays, as.list)
        ) %>%
        arrange(gw_id)

saveRDS(events_clean, "data/processed/events_clean.rds")


## Clean fixtures
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
        mutate(
                across(
                        c(
                                code,
                                gw_id,
                                fixture_id,
                                minutes,
                                away_team,
                                away_team_score,
                                home_team,
                                home_team_score,
                                home_team_difficulty,
                                away_team_difficulty,
                                pl_fixture_id
                        ),
                        as.integer
                ),
                across(
                        c(
                                finished,
                                finished_provisional,
                                started
                        ),
                        as.logical
                ),
                across(kickoff_time, ~ as.POSIXct(., format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")),
                across(stats, as.list)
        ) %>%
        arrange(gw_id, fixture_id)

saveRDS(fixtures_clean, "data/processed/fixtures_clean.rds")


##Clean phases
phases_clean <- phases %>%
        rename(start_gw = start_event,
               stop_gw = stop_event,
               phase_id = id) %>%
        mutate(
                across(
                        c(
                                phase_id,
                                start_gw,
                                stop_gw,
                                highest_score
                        )
                ),
                across(name, as.factor)
        ) %>%
        arrange(phase_id)

saveRDS(phases_clean, "data/processed/phases_clean.rds")


## Clean player_types
player_types_clean <- player_types %>%
        select(-c(plural_name_short, squad_min_select, squad_max_select),
                  position_id = id,
                  player_count = element_count,
                  squad_min_players = squad_min_play,
                  squad_max_players = squad_max_play) %>%
        mutate(
                across(
                        c(
                                position_id,
                                squad_min_players,
                                squad_max_players,
                                squad_select,
                                sub_positions_locked,
                                player_count
                        ),
                        as.integer
                ),
                across(
                        c(
                                plural_name, 
                                singular_name, 
                                singular_name_short
                        ),
                        as.factor
                ),
                across(ui_shirt_specific, as.logical)
        ) %>%
        arrange(position_id)

saveRDS(player_types_clean, "data/processed/player_types_clean.rds")


## Clean players
players_clean <- players %>%
        filter(can_select == TRUE) %>%
        select(
                second_name, 
                first_name, id, 
                team, total_points, 
                everything(), 
                -c(
                        can_transact, 
                        can_select, 
                        photo, 
                        removed, 
                        special, 
                        squad_number
                ),
               player_code = code,
               player_type = element_type,
               exp_points_next_gw = ep_next,
               exp_points_this_gw = ep_this,
               gw_points = event_points,
               player_id = id,
               transfers_in_gw = transfers_in_event,
               transfers_out_gw = transfers_out_event,
               minutes_played = minutes,
               team_id = team
               ) %>%
        mutate(
                across(
                        c(
                                player_id:player_type,
                                gw_points,
                                now_cost,
                                team_code:transfers_out_gw,
                                region,
                                minutes_played:bonus
                        ),
                        as.integer
                ),
                across(
                        c(
                                exp_points_next_gw,
                                exp_points_this_gw,
                                form,
                                points_per_game,
                                selected_by_percent,
                                value_form,
                                value_season
                        ),
                        as.numeric
                ),
                across(
                        c(
                                second_name,
                                first_name,
                                news,
                                web_name,
                                opta_code
                        ),
                        as.character
                ),
                across(
                        c(
                                in_dreamteam,
                                has_temporary_code
                        ),
                        as.logical
                ),
                across(news_added, ~ as.POSIXct(., format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")),
                status = factor(status, levels = c("a", "i", "u", "d", "n"))
        ) %>%
        arrange(desc(total_points), second_name)

saveRDS(players_clean, "data/processed/players_clean.rds")


## Clean teams
teams_clean <- teams %>%
        select(id, name, position, strength, everything(), -c(team_division, unavailable),
               team_code = code,
               team_id = id,
               pl_team_id = pulse_id) %>%
        mutate(
                across(
                        c(
                                team_id,
                                position:draw,
                                loss:points,
                                win:pl_team_id
                        ),
                        as.integer
                ),
                across(
                        c(
                                name,
                                short_name
                        ),
                        as.factor
                ),
                across(form, as.numeric)
        ) %>%
        arrange(team_id)

saveRDS(teams_clean, "data/processed/teams_clean.rds")

## Clean player_stats_labels
player_stats_labels_clean <- player_stats_labels %>% mutate(across(1:2, as.character))
saveRDS(player_stats_labels_clean, "data/processed/player_stats_labels_clean.rds")


total_players <- as.integer(total_players)
saveRDS(total_players, "data/processed/total_players_clean.rds")

saveRDS(game_config, "data/processed/game_config_clean.rds")
saveRDS(game_settings, "data/processed/game_settings_clean.rds")