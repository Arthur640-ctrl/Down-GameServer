extends Node3D

@onready var player: CharacterBody3D = $".."
@onready var animation_tree: AnimationTree = $"mixamo_base/animation tree"

var animations_packet = null
var visibile_animation = false

func is_approx_equal(vec1: Vector2, vec2: Vector2, epsilon := 0.05) -> bool:
	return vec1.distance_to(vec2) < epsilon

func transform_input_animation(input_dir):
	"""
	Transform input_dir for make animations
	This function return : the vector of BlendSpace2D, timescale
	"""
	var timescale = null
	if input_dir.is_equal_approx(Vector2(0, -1)):
		timescale = 1
		return [Vector2(0, 1), timescale]
	elif input_dir.is_equal_approx(Vector2(0, 1)):
		timescale = -1
		return [Vector2(0, 1), timescale]
	elif input_dir.is_equal_approx(Vector2(-1, 0)):
		timescale = 1
		return [Vector2(-1, 0), timescale]
	elif input_dir.is_equal_approx(Vector2(1, 0)):
		timescale = 1
		return [Vector2(1, 0), timescale]
		
	elif input_dir.is_equal_approx(Vector2(-0.707107, -0.707107)):
		timescale = 1
		return [Vector2(-0.5, 0.5), timescale]
	elif input_dir.is_equal_approx(Vector2(0.707107, -0.707107)):
		timescale = 1
		return [Vector2(0.5, 0.5), timescale]
		
	elif input_dir.is_equal_approx(Vector2(0.707107, 0.707107)):
		timescale = -1
		return [Vector2(-0.5, 0.5), timescale]
	elif input_dir.is_equal_approx(Vector2(-0.707107, 0.707107)):
		timescale = -1
		return [Vector2(0.5, 0.5), timescale]
		
	elif input_dir.is_equal_approx(Vector2(0, 0)):
		timescale = 1
		return [Vector2(0, 0), timescale]

func set_animation(inputs, direction):
	var animation_packet = {
		"timescale": 1,
		"blend_space_position": [0, 0],
		"state": "idle"
	}

	var input_dir = inputs.get("input_dir", Vector2.ZERO)
	var is_crouched = inputs.get("is_crouched", false)
	var is_running = inputs.get("is_running", false)

	var input_dir_animation_result = transform_input_animation(input_dir)
	var blend_space_position = input_dir_animation_result[0]
	var timescale = input_dir_animation_result[1]

	animation_packet["blend_space_position"] = [blend_space_position.x, blend_space_position.y]
	animation_packet["timescale"] = timescale

	# 🚨 PRIORITY FOR "in_air"
	if not player.is_on_floor():
		animation_packet["state"] = "in_air"
		return animation_packet

	# 🧍 Immobile
	if input_dir == Vector2.ZERO:
		if is_crouched:
			animation_packet["state"] = "idle_crouched"
		else:
			animation_packet["state"] = "idle"
		return animation_packet

	# 🚶 Mouvement
	if is_crouched:
		animation_packet["state"] = "crouched"
	elif is_running and Globals.player_bars[player.PLAYER_ID]["stamina"] > 0:
		animation_packet["state"] = "running"
	else:
		animation_packet["state"] = "walking"
	
	animations_packet = animation_packet
	return animation_packet

var mouvement_transition = "parameters/mouvement/transition_request"
var inMove_transition = "parameters/in_move/transition_request"
var walking_blend2d = "parameters/walking/blend_position"
var croushed_blend2d = "parameters/croushed/blend_position"
var idle_transition = "parameters/idle_type/transition_request"
var croushed_timescale = "parameters/croushed_timescale/scale"
var walking_timescale = "parameters/walking_timescale/scale"
var isjumping_transition = "parameters/is_jumping/transition_request"
var gunblend_blend2 = "parameters/gun_blend/blend_amount"

var current_blend = Vector2.ZERO

func _process(delta: float) -> void:
	if animations_packet != null and visibile_animation:
		if typeof(animations_packet) == TYPE_DICTIONARY and animations_packet.has("timescale"):
			if animations_packet["timescale"] != null:
				animation_tree[croushed_timescale] = animations_packet["timescale"]
				animation_tree[walking_timescale] = animations_packet["timescale"]

		if typeof(animations_packet) == TYPE_DICTIONARY and animations_packet.has("state") and animations_packet.has("blend_space_position"):
			var target_blend = Vector2(animations_packet["blend_space_position"][0], animations_packet["blend_space_position"][1])
			
			if current_blend != Vector2.ZERO:
				current_blend = current_blend.lerp(target_blend, delta * 8.0)
			else:
				current_blend = target_blend
			
			animation_tree.set(croushed_blend2d, current_blend)
			animation_tree.set(walking_blend2d, current_blend)

			if animations_packet["state"] == "in_air":
				animation_tree[isjumping_transition] = "jumping"
			else:
				animation_tree[isjumping_transition] = "on_floor"
				if animations_packet["state"] == "walking":
					animation_tree[mouvement_transition] = "walking"
					animation_tree[inMove_transition] = "moving"
				elif animations_packet["state"] == "running":
					animation_tree[mouvement_transition] = "running"
					animation_tree[inMove_transition] = "moving"
				elif animations_packet["state"] == "crouched":
					animation_tree[mouvement_transition] = "croushed"
					animation_tree[inMove_transition] = "moving"
				else:
					animation_tree[inMove_transition] = "standing"
					if animations_packet["state"] == "idle":
						animation_tree[idle_transition] = "idle"
					elif animations_packet["state"] == "idle_crouched":
						animation_tree[idle_transition] = "idle_croushed"
