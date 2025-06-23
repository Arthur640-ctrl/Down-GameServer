extends Node3D

@onready var cage: Node3D = $ascenteur/cage


func _process(delta: float) -> void:
	Globals.entities["cage"]["position"] = [cage.position.x, cage.position.y, cage.position.z]
	Globals.entities["cage"]["rotation"] = [cage.rotation.x, cage.rotation.y, cage.rotation.z]
