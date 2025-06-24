extends Node

@onready var player: CharacterBody3D = $".."

var PLAYER_ID = null

var actual_slot = 0

var base_inventory = {
	"active":
		[
			{
				"item": 100002,
				"number": null,
				"rarity": 3
			},
			{
				"item": null,
				"number": null,
				"rarity": null
			},
			{
				"item": null,
				"number": null,
				"rarity": null
			}
		],
	"passive":
		[
			{
				"item": null,
				"number": null,
				"rarity": null
			},
			{
				"item": null,
				"number": null,
				"rarity": null
			},
			{
				"item": null,
				"number": null,
				"rarity": null
			},
			{
				"item": null,
				"number": null,
				"rarity": null
			}
		],
	"bullets": {
		
	}
}

# DEBUG :
var last_slot = 0
var last_inv_up = false
var last_inv_down = false

func _ready():
	PLAYER_ID = player.PLAYER_ID

func _process(delta: float) -> void:
	if PLAYER_ID != null and not Globals.players_inventory.has(PLAYER_ID):
		Globals.players_inventory[PLAYER_ID] = {
			"inventory": base_inventory,
			"actual_slot": 0
		}

	if PLAYER_ID != null and Globals.players_inputs.has(PLAYER_ID):
		var inv_up = Globals.players_inputs[PLAYER_ID].get("inv_up", false)
		var inv_down = Globals.players_inputs[PLAYER_ID].get("inv_down", false)

		if inv_up and not last_inv_up:
			if actual_slot == 2:
				actual_slot = 0
			else:
				actual_slot += 1

		if inv_down and not last_inv_down:
			if actual_slot == 0:
				actual_slot = 2
			else:
				actual_slot -= 1

		last_inv_up = inv_up
		last_inv_down = inv_down

	Globals.players_inventory[PLAYER_ID]["actual_slot"] = actual_slot
