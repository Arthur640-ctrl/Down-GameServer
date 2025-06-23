extends Node3D

var speed: float = 100.0
var damage: float = 50.0
var gravity: float = 0.0
var vertical_velocity: float = 0.0
var hit_player = null
var start_position: Vector3

@onready var detection: Area3D = $Area3D

func _ready() -> void:
	start_position = global_transform.origin
	detection.collision_mask = 4
	detection.collision_layer = 1
	detection.monitoring = true
	detection.monitorable = true
	detection.connect("area_entered", Callable(self, "_on_area_3d_area_entered"))

func _process(delta: float) -> void:
	position += global_transform.basis.z * speed * delta
	vertical_velocity -= gravity * delta
	position.y += vertical_velocity * delta

func _on_area_3d_area_entered(area: Area3D) -> void:
	if hit_player != null:
		return  

	if "damage_multiplier" in area:
		var player = area.get_owner_player()
		if player and player.has_method("take_damage"):
			hit_player = player  # On stocke le joueur touché pour éviter les doublons
			var multiplier = area.damage_multiplier
			player.take_damage(damage * multiplier)
			print("Touché :", area.part_name, " -> Dégâts :", damage * multiplier)
			var current_position = global_transform.origin
			var distance_traveled = start_position.distance_to(current_position)
			print("Distance parcourue avant collision : ", distance_traveled)
			queue_free()
