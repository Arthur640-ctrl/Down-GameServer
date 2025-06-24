extends Node

var RequestHandler = null
var Server = null

func brodcast_word():
	var all_players_data = {}
	
	for player_id in Globals.active_sessions.values():
		if Globals.players_infos.has(player_id) and Globals.player_bars.has(player_id) and Globals.players_inventory.has(player_id):
			var info = Globals.players_infos[player_id]
			var bars = Globals.player_bars[player_id]
			var inventory = Globals.players_inventory[player_id]
				
			all_players_data[player_id] = {
				"position": info.get("position", [0, 0, 0]),
				"rotation": info.get("rotation", [0, 0, 0]),
				"camera_rotation": info.get("camera_rotation", [0, 0, 0]),
				"animations": info.get("animations", {}),  
				"stamina": bars.get("stamina", 100),
				"health": bars.get("health", 100),
				"inventory": inventory.get("inventory", {}),
				"actual_slot": inventory.get("actual_slot", 0)
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
