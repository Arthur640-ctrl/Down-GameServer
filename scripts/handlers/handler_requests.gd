extends Node

var LoginHandler = null  # juste preload la classe
var PlayerHandler = null  # on met null, on va assigner l’instance plus tard

func request_process(request: Dictionary, client):
	if request.get("request") == "login":
		LoginHandler.handle_login(request, client)
	elif request.get("request") == "player_actualisation":
		PlayerHandler.handle_player_actualisation(request, client)
	else:
		send_error("Requête inconnue.", client)

func send_response(data: Dictionary, client):
	var json = JSON.new()
	var response_str = json.stringify(data)
	client.put_packet(response_str.to_utf8_buffer())

func send_error(message: String, client):
	send_response({
		"response": "error",
		"message": message
	}, client)
