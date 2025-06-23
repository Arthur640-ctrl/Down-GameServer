extends Node

var server := UDPServer.new()
var clients := []

var player_scene = preload("res://scenes/player.tscn")

var RequestHandler = preload("res://scripts/handlers/handler_requests.gd").new()
var PlayerHandler = preload("res://scripts/handlers/handler_player.gd").new()
var WorldHandler = preload("res://scripts/handlers/handler_world.gd").new()
var LoginHandler = preload("res://scripts/handlers/handler_login.gd").new()

var player_instances = {}

func _ready():
	var result = server.listen(8000)
	if result == OK:
		print("Serveur prêt sur port 8000")
	else:
		print("Erreur serveur : %s" % result)

	# Assignation des références pour éviter boucle infinie
	# -- RequestHandler --
	RequestHandler.PlayerHandler = PlayerHandler
	RequestHandler.LoginHandler = LoginHandler
	# -- Login --
	LoginHandler.PlayerHandler = PlayerHandler
	LoginHandler.RequestHandler = RequestHandler
	LoginHandler.Server = self
	# -- Player --
	PlayerHandler.RequestHandler = RequestHandler
	PlayerHandler.Server = self
	# -- Word --
	WorldHandler.Server = self
	WorldHandler.RequestHandler = RequestHandler

func _process(_delta):
	server.poll()
	
	while server.is_connection_available():
		var new_peer = server.take_connection()
		if new_peer:
			clients.append(new_peer)
	
	for client in clients:
		while client.get_available_packet_count() > 0:
			var packet = client.get_packet()
			var message = packet.get_string_from_utf8().strip_edges()
			
			if Globals.message_content_debug:
				print("Message reçu : ", message)

			var json = JSON.new()
			if json.parse(message) == OK:
				var request = json.get_data()
				RequestHandler.request_process(request, client)
				
	WorldHandler.brodcast_word()
