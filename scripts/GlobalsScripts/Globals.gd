extends Node

# Server settings :
const SERVER_PORT = 8000
const SERVER_IP = "0.0.0.0"

const accepted_peer_debug = false
const message_content_debug = false

var players = {
	"player_id_1": {"token": "abcdef"},
	"player_id_2": {"token": "ghijkl"},
}

var active_sessions = {
	# Exemple : "192.168.1.5:54000" : "player_id_1"
}

var players_inputs = {
	"player1": {
		"input_dir": null,
		"mouse_event": null,
		"is_running": null,
		"is_jumping": null,
		"is_crouched": null
	}
}

var players_infos = {
	"player1": {
		"position": null,
		"rotation": null,
		"camera_rotation": null,
		"animations": null,
		"ray_cast": null,
	}
}

var player_bars = {
	"player1": {
		"health": 100,
		"stamina": 100,
	}
}

var player_inventory = {
	
}

var players_inventory = {
	"player1": {
		
	}
}

# Game settings : 
var WALKING_SPEED = 3  
var RUNNING_SPEED = 5
var CROUSHED_SPEED = 1.5

var TIRED_REDUCE_SPEED = 1

const BULLET_SCENE_PATH = "res://scenes/bullet.tscn"

var entities = {
	"cage": {
		"position": [0, 0, 0],
		"rotation": [0, 0, 0]
	}
}
