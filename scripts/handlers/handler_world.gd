extends Node

var RequestHandler = null
var Server = null

func brodcast_word():
	var all_players_data = {}
	
	for player_id in Globals.active_sessions.values():
		if Globals.players_infos.has(player_id) and Globals.player_bars.has(player_id):
			var info = Globals.players_infos[player_id]
			var bars = Globals.player_bars[player_id]
			all_players_data[player_id] = {
				"position": info.get("position", [0, 0, 0]),
				"rotation": info.get("rotation", [0, 0, 0]),
				"camera_rotation": info.get("camera_rotation", [0, 0, 0]),
				"animations": info.get("animations", {}),  
				"stamina": bars["stamina"],
				"health": bars["health"]
			}
	
	var all_entities_data = Globals.entities
	
	# Créer le payload à envoyer
	var payload = {
		"message": "word_actualisation",
		"players": all_players_data,
		"entities": all_entities_data
	}
	
	# Envoyer à tous les clients
	for client in Server.clients:
		if client == null:
			continue
		RequestHandler.send_response(payload, client)
