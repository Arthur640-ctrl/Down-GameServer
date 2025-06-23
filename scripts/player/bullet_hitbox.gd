extends Area3D

@export var damage_multiplier: float = 1.0
@export var part_name: String = ""  # pour debug ou effets

func _ready() -> void:
	collision_layer = 4
	collision_mask = 1
	monitoring = true
	monitorable = true
	set_damage_multiplier()


func get_owner_player():
	return get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()  # BoneAttachment > Skeleton > Node > mixamo_base > visuals > Joueur

func set_damage_multiplier():
	if part_name.to_lower() == "end":
		damage_multiplier = GameRules.end_damage_multiplier
	elif part_name.to_lower() == "body":
		damage_multiplier = GameRules.body_damage_multiplier
	elif part_name.to_lower() == "head":
		damage_multiplier = GameRules.head_damage_multiplier
