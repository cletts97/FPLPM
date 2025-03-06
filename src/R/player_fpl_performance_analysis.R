library(dplyr)

players <- readRDS("data/processed/players_clean.rds")

players_small <- players %>%
        select(web_name, now_cost, total_points, minutes_played, player_type, player_id, team_id) %>%
        filter(as.integer(player_type) != 5 & as.integer(minutes_played) > 300) %>%
        mutate(
                total_points = ifelse(is.na(total_points), 0, total_points),
                minutes_played = ifelse(is.na(minutes_played), 0, minutes_played)) %>%
        mutate(points_per_90 = if_else(as.integer(minutes_played) > 0, (total_points / minutes_played) * 90, 0)) %>%
        arrange(desc(points_per_90))