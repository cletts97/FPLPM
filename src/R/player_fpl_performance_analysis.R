library(dplyr)

players <- readRDS("data/processed/players_clean.rds")

players_points_per_90 <- players %>%
        select(web_name, now_cost, total_points, minutes_played, player_type, player_id, team_id) %>%
        filter(player_type != 5 & minutes_played > 300) %>%
        mutate(
                total_points = ifelse(is.na(total_points), 0, total_points),
                minutes_played = ifelse(is.na(minutes_played), 0, minutes_played)) %>%
        mutate(points_per_90 = if_else(minutes_played > 0, (total_points / minutes_played) * 90, 0)) %>%
        arrange(desc(points_per_90))

saveRDS(players_points_per_90, "reports/performance_analysis/players_points_per_90.rds")