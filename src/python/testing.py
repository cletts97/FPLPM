import requests

url = "https://fantasy.premierleague.com/api/bootstrap-static/"
response = requests.get(url)
data = response.json()

# Print the keys to see what data is available
print(data.keys())

# Example: Inspecting player data
players = data['elements']
print(f"Number of players: {len(players)}")
print(players[0])  # See the first player's data