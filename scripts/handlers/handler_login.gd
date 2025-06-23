extends Node

var RequestHandler = null
var PlayerHandler = null
var Server = null

var last = 0

func handle_login(request: Dictionary, client):
	var player_id = request.get("player_id", "")
	var player_token = request.get("player_token", "")

	if not Globals.players.has(player_id):
		RequestHandler.send_error("Joueur inconnu.", client)
		return

	if Globals.players[player_id]["token"] != player_token:
		RequestHandler.send_error("Token invalide.", client)
		return

	var peer_ip = client.get_packet_ip()
	var peer_port = client.get_packet_port()
	var peer_signature = Utils.create_signature(peer_ip, peer_port)

	for signature in Globals.active_sessions.keys():
		var existing_id = Globals.active_sessions[signature]
		if Utils.is_signature_equal(existing_id, player_id):
			RequestHandler.send_error("Ce joueur est déjà connecté.", client)
			return

	Globals.active_sessions[peer_signature] = player_id
	print("✅ %s connecté depuis %s" % [player_id, peer_signature])
	
	Server.clients.append(client)
	
	PlayerHandler.spawn_player(player_id, Vector3(last, 0, 0))
	
	RequestHandler.send_response({
		"response": "ok",
		"message": "Connexion réussie"
	}, client)
