## https://fantasy.premierleague.com/api/element-summary/{player_id}/
## https://fantasy.premierleague.com/api/leagues-classic/{league_id}/standings/
## https://fantasy.premierleague.com/api/event/{event_id}/live/
## https://fantasy.premierleague.com/api/entry/{manager_id}/
## https://fantasy.premierleague.com/api/my-team/{manager_id}/
## https://fantasy.premierleague.com/api/me/

library(httr)
library(jsonlite)

main_data_url <- "https://fantasy.premierleague.com/api/bootstrap-static/"
fixtures_url <- "https://fantasy.premierleague.com/api/fixtures"

response <- GET(main_data_url)

if (http_status(response)$category == "Success") {
        # Parse JSON content
        data <- fromJSON(content(response, "text"), flatten = TRUE)
        print("Main data fetched successfully!")
} else {
        stop("Failed to fetch main data. Status code: ", http_status(response)$message)
}

saveRDS(data[["chips"]], "data/raw/chips_data.rds")
saveRDS(data[["events"]], "data/raw/events.rds")
saveRDS(data[["game_settings"]], "data/raw/game_settings.rds")
saveRDS(data[["game_config"]], "data/raw/game_config.rds")
saveRDS(data[["phases"]], "data/raw/phases.rds")
saveRDS(data[["teams"]], "data/raw/teams.rds")
saveRDS(data[["total_players"]], "data/raw/total_players.rds")
saveRDS(data[["element_stats"]], "data/raw/player_stats_labels.rds")
saveRDS(data[["element_types"]], "data/raw/player_types.rds")
saveRDS(data[["elements"]], "data/raw/players.rds")


response <- GET(fixtures_url)

if (http_status(response)$category == "Success") {
        # Parse JSON content
        data <- fromJSON(content(response, "text"), flatten = TRUE)
        print("Fixtures data fetched successfully!")
} else {
        stop("Failed to fetch fixtures data. Status code: ", http_status(response)$message)
}

saveRDS(data, "data/raw/fixtures.rds")