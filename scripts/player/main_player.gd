extends CharacterBody3D

@onready var animations: Node3D = $visuals
@onready var main_ray: RayCast3D = $camera_mount/main_ray
@onready var camera_mount: Node3D = $camera_mount

var SPEED = 3
const JUMP_VELOCITY = 4.0
var PLAYER_ID = null
var direction = null
var animation_packet = null

func get_player_id() -> String:
	return PLAYER_ID

func set_player_id(id: String) -> void:
	PLAYER_ID = id

func _physics_process(delta: float) -> void:
	if PLAYER_ID == null:
		return

	if not Globals.players_infos.has(PLAYER_ID):
		Globals.players_infos[PLAYER_ID] = {
			"position": [0,0,0],
			"rotation": [0,0,0],
			"camera_rotation": [0,0,0],
			"animations": {}
		}
		
	if not Globals.player_bars.has(PLAYER_ID):
		Globals.player_bars[PLAYER_ID] = {
			"health": 100,
			"stamina": 100
	}

	if not Globals.players_inputs.has(PLAYER_ID):
		return

	Globals.players_infos[PLAYER_ID]["position"] = [position.x, position.y, position.z]
	Globals.players_infos[PLAYER_ID]["rotation"] = [rotation_degrees.x, rotation_degrees.y, rotation_degrees.z]
	Globals.players_infos[PLAYER_ID]["animations"] = animation_packet

	var inputs = Globals.players_inputs[PLAYER_ID]
	
	var new_inputs = update_stamina_run(inputs["is_running"], inputs["is_jumping"], inputs["input_dir"])
	inputs["is_running"] = new_inputs[0]
	inputs["is_jumping"] = new_inputs[1]
	
	if inputs.has("is_shooting"):
		if inputs["is_shooting"]:
			shoot()

	if not is_on_floor():
		velocity += get_gravity() * delta

	if inputs.get("is_jumping", false) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = null
	if inputs.has("input_dir"):
		input_dir = inputs["input_dir"]

	if inputs.get("is_running", false):
		SPEED = Globals.RUNNING_SPEED
	elif inputs.get("is_crouched", false):
		SPEED = Globals.CROUSHED_SPEED
	else:
		SPEED = Globals.WALKING_SPEED

	if input_dir != null:
		direction = (transform.basis * Vector3(input_dir[0], 0, input_dir[1])).normalized()
		if direction.length() > 0:
			var air_control_factor = 0.1  # ← 0.0 = pas de contrôle, 1.0 = contrôle total

			if is_on_floor():
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				velocity.x = lerp(velocity.x, direction.x * SPEED, air_control_factor)
				velocity.z = lerp(velocity.z, direction.z * SPEED, air_control_factor)

		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	
	animation_packet = animations.set_animation(inputs, direction)
	move_and_slide()

func update_stamina_run(is_running, is_jumping, input_dir_arg):
	if input_dir_arg == null:
		input_dir_arg = [0, 0]
	"""
	Return : 
		[0] = is_running
		[1] = is_jumping
	"""
	if not Globals.player_bars.has(PLAYER_ID):
		return false
	var stamina = Globals.player_bars[PLAYER_ID]["stamina"]
	var input_dir = Vector2(input_dir_arg[0], input_dir_arg[1])

	if is_running and input_dir != Vector2.ZERO:
		if input_dir.y > 0 or input_dir.x > 0 or input_dir.x < 0:
			is_running = false
		elif stamina > 0:
			stamina -= 15 * get_physics_process_delta_time()
		else:
			is_running = false
	else:
		if stamina < 100:
			stamina += 15 * get_physics_process_delta_time()

			
	if is_jumping and is_on_floor():
		var jump_cost = 10 if is_running else 5
		if stamina >= jump_cost:
			stamina -= jump_cost
		else:
			is_jumping = false


	stamina = clamp(stamina, 0, 100)
	Globals.player_bars[PLAYER_ID]["stamina"] = stamina

	return [is_running, is_jumping]

func shoot():
	print("Shoot !")
	main_ray.shoot()

func update_canon_rotation():
	var rot_y = Quaternion(Vector3.UP, deg_to_rad(rotation_degrees.y))
	
	var rot_x = Quaternion(Vector3.RIGHT, deg_to_rad($camera_mount.rotation_degrees.x))
	
	var combined_rot = rot_y * rot_x
	
	$"Canon".global_transform.basis = Basis(combined_rot)

func take_damage(amount: float):
	Globals.player_bars[PLAYER_ID]["health"] -= amount
	print("PV restants :", Globals.player_bars[PLAYER_ID]["health"])
	
	if Globals.player_bars[PLAYER_ID]["health"] <= 0:
		Utils.set_player_died(PLAYER_ID)
		queue_free() 
