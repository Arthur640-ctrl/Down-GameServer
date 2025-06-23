extends Node

var RequestHandler = null
var Server = null

func handle_player_actualisation(request: Dictionary, client):
	var input_dir = request.get("input_dir")
	var player_id = request.get("player_id")
	var mouse_event = request.get("mouse_event")
	
	var is_running = request.get("is_running")
	var is_crouched = request.get("is_crouched")
	var is_jumping = request.get("is_jumping")
	var is_shooting = request.get("is_shooting")
	
	var inv_up = request.get("inv_up")
	var inv_down = request.get("inv_down")
	
	var peer_ip = client.get_packet_ip()
	var peer_port = client.get_packet_port()
	var peer_signature = Utils.create_signature(peer_ip, peer_port)
	
	Utils.ensure_player_input_exists(player_id)
	Utils.ensure_player_info_exists(player_id)
	
	if Globals.message_content_debug:
		print("📥 Requête input_dir reçue de %s (%s:%s)" % [player_id, peer_ip, peer_port])

	if not Globals.players.has(player_id):
		print("❌ Joueur inconnu :", player_id)
		RequestHandler.send_error("player_id_inconnue", client)
		return
	
	if not Globals.active_sessions.has(peer_signature):
		print("❌ Joueur pas connecté :", peer_signature)
		RequestHandler.send_error("player_non_connecte", client)
		return
	
	if Globals.active_sessions[peer_signature] != player_id:
		print("❌ Session invalide pour :", player_id)
		RequestHandler.send_error("session_invalide", client)
		return
	
	
	Globals.players_inputs[player_id]["input_dir"] = Vector2(input_dir[0], input_dir[1])
	Globals.players_inputs[player_id]["mouse_event"] = mouse_event
	Globals.players_inputs[player_id]["is_running"] = is_running
	Globals.players_inputs[player_id]["is_crouched"] = is_crouched
	Globals.players_inputs[player_id]["is_jumping"] = is_jumping
	Globals.players_inputs[player_id]["is_shooting"] = is_shooting
	Globals.players_inputs[player_id]["inv_up"] = inv_up
	Globals.players_inputs[player_id]["inv_down"] = inv_down
	
	if Globals.message_content_debug:
		print("✅ input_dir reçu :", Globals.players_inputs[player_id]["input_dir"])
	
	if Globals.message_content_debug:
		print("✅ mouse_event reçu :", Globals.player_mouse[player_id]["mouse_event"])
		
	RequestHandler.send_response({
		"response": "ok",
		"message": "Input direction reçue"
	}, client)

func spawn_player(player_id: String, position: Vector3) -> void:
	if Server.player_instances.has(player_id):
		print("Le joueur existe déjà :", player_id)
		return
	
	var player_instance = Server.player_scene.instantiate()
	player_instance.set_player_id(player_id)
	player_instance.position = position
	Server.add_child(player_instance)  # ajoute l'instance dans la scène actuelle, important !
	
	Server.player_instances[player_id] = player_instance
