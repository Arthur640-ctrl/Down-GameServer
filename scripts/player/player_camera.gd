extends Node3D
@onready var player: CharacterBody3D = $".."
@onready var canon: Node3D = $"../Canon"


func _process(delta: float) -> void:
	var inputs = Globals.players_inputs.get(player.PLAYER_ID, null)
	if typeof(inputs) == TYPE_DICTIONARY and inputs.has("mouse_event"):
		var mouse_event = inputs["mouse_event"]
		
		if typeof(mouse_event) == TYPE_DICTIONARY and \
		   mouse_event.has("relative") and \
		   mouse_event.has("sens_horizontal") and \
		   mouse_event.has("sens_vertical"):
			
			var relative_data = mouse_event["relative"]
			if typeof(relative_data) == TYPE_ARRAY and relative_data.size() == 2:
				var relative = Vector2(relative_data[0], relative_data[1])
				
				# Si relative n'est pas (0, 0), on applique la rotation
				if relative != Vector2.ZERO:
					var sens_horizontal = mouse_event["sens_horizontal"]
					var sens_vertical = mouse_event["sens_vertical"]
					
					player.rotate_y(deg_to_rad(-relative.x * sens_horizontal))
					
					var new_x_rot = rotation_degrees.x - relative.y * sens_vertical
					new_x_rot = clamp(new_x_rot, -90, 90)
					rotation_degrees.x = new_x_rot
					
	
	if Globals.players_infos.has(player.PLAYER_ID):
		Globals.players_infos[player.PLAYER_ID]["camera_rotation"] = [rotation_degrees.x, rotation_degrees.y, rotation_degrees.z]
	else:
		# Initialiser les données du joueur s’il n’existe pas encore
		Globals.players_infos[player.PLAYER_ID] = {
			"position": [0, 0, 0],
			"rotation": [0, 0, 0],
			"camera_rotation": [rotation_degrees.x, rotation_degrees.y, rotation_degrees.z]
		}
