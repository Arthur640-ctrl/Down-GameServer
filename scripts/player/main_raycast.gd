extends RayCast3D

@onready var player: CharacterBody3D = $"../.."

var PLAYER_ID = null
var bullet_scene = preload("res://scenes/bullet.tscn")



func _ready() -> void:
	PLAYER_ID = player.PLAYER_ID

func _process(delta: float) -> void:
	if is_colliding():
		var target = get_collider()
		var origin = global_transform.origin
		
		if target and origin:
			# Récupérer la position de l'objet cible
			var target_pos = target.global_transform.origin
			
			# Calculer la distance entre l'origine du raycast et la cible
			var distance = origin.distance_to(target_pos)
			
			#print("Touché :", target.name)
			Globals.players_infos[PLAYER_ID]["ray_cast"] = target.name

func shoot():
	var bullet = bullet_scene.instantiate() as Node3D
	
	bullet.global_transform = $Canon.global_transform
	bullet.scale = Vector3(0.1, 0.1, 0.1)
	
	get_tree().root.call_deferred("add_child", bullet)





	
	


	
	
