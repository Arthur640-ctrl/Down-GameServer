extends Node

func get_player_infos(player_id):
	if Globals.players_infos.has(player_id):
		return Globals.players_infos.get(player_id, null)
	else:
		return false
		
func is_player_running(player_id):
	if Globals.players_infos.has(player_id):
		var player_inputs =  Globals.players_inputs.get(player_id, null)
		if player_inputs != null and player_inputs.has("is_running"):
			return player_inputs["is_running"]
		else:
			return false
	else:
		return false
	
