extends Node

func create_signature(ip, port):
	return "%s:%s" % [ip, port]

func is_signature_equal(a, b):
	if a == b:
		return true
	else:
		return false

func is_peer_authenticated(peer: PacketPeerUDP) -> bool:
	return get_authenticated_player(peer) != ""

func get_authenticated_player(peer: PacketPeerUDP) -> String:
	if not peer:
		return ""

	var signature = create_signature(peer.get_packet_ip(), peer.get_packet_port())
	
	if Globals.active_sessions.has(signature):
		return Globals.active_sessions[signature]
	
	return ""

func ensure_player_input_exists(player_id: String) -> void:
	if not Globals.players_inputs.has(player_id):
		Globals.players_inputs[player_id] = {
			"input_dir": null,
			"mouse_event": null,
			"is_running": null,
			"is_jumping": null,
			"is_crouched": null
		}

func ensure_player_info_exists(player_id: String) -> void:
	if not Globals.players_infos.has(player_id):
		Globals.players_infos[player_id] = {
			"position": null,
			"rotation": null,
			"camera_rotation": null,
			"animations": null,
			"ray_cast": null,
		}

func set_player_died(PLAYER_ID):
	
	if Globals.players_inputs.has(PLAYER_ID) and Globals.players_infos.has(PLAYER_ID):
		Globals.players_inputs.erase(PLAYER_ID)
		Globals.players_infos.erase(PLAYER_ID)
	
