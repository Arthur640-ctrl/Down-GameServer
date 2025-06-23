extends Node

# 1xxxxx → armes
# 2xxxxx → munitions
# 3xxxxx → consommables
# 4xxxxx → armures

# ===== Pour armes =====
#| Nom                | Type          | Description                                                    |
#| ------------------ | ------------- | -------------------------------------------------------------- |
#| `id`               | `int`         | ID unique de l’arme (ex: `100001`)                             |
#| `name`             | `String`      | Nom affiché (ex: `"Pistolet Faucheur"`)                        |
#| `type`             | `String`      | `"gun"` (pour savoir que c'est une arme à feu)                 |
#| `damage`           | `int / float` | Dégâts infligés par balle                                      |
#| `fire_rate`        | `float`       | Cadence de tir en **balle/sec** ou délai entre tirs            |
#| `magazine_size`    | `int`         | Nombre de balles max par chargeur                              |
#| `reload_time`      | `float`       | Temps pour recharger en secondes                               |
#| `ammo_type`        | `int`         | ID de la munition utilisée                                     |
#| `range`            | `float`       | Portée efficace de l’arme (en mètres, ou unités)               |
#| `is_automatic`     | `bool`        | True = tir auto (mitrailleuse), False = semi-auto (pistolet)   |
#| `icon`             | `Texture`     | Icône pour l’UI/inventaire                                     |
#| `model`            | `PackedScene` | Modèle 3D (optionnel) à instancier en main                     |
#| `speed`            | `int / float` | Vitesse de la balle de l'arme                                  |

# Optionnel :
#| Nom                | Type          | Description                                                      |
#| ------------------ | ------------- | ---------------------------------------------------------------- |
#| `spread`           | `float`       | Dispersion du tir (utile pour fusils à pompe ou tirs non précis) |
#| `recoil`           | `float`       | Recul ressenti ou animation                                      |
#| `burst_count`      | `int`         | Si tir en rafale : nombre de tirs par clic                       |
#| `penetration`      | `float`       | Capacité à traverser plusieurs cibles ou obstacles               |
#| `sound_shot`       | `AudioStream` | Son joué au tir                                                  |
#| `sound_reload`     | `AudioStream` | Son joué au rechargement                                         |
#| `muzzle_flash`     | `PackedScene` | Effet visuel à l’embouchure                                      |
#| `shoot_animation`  | `String`      | Nom de l’anim à jouer quand on tire                              |
#| `reload_animation` | `String`      | Nom de l’anim à jouer quand on recharge                          |
#| `aim_zoom`         | `float`       | Zoom appliqué lors du viseur (ADS - Aim Down Sight)              |


var ITEMS = {
	100001: {
		"name": "Fusils d'Assaut Faucheur",
		"type": "gun",
		"damage": 25,
		"fire_rate": 0.5,
		"magazine_size": 12,
		"reload_time": 1.8,
		"ammo_type": 200001,
		"range": 30.0,
		"is_automatic": false,
		"icon": null,
		"model": null,
		"speed": 500,
	},
	100002: {
		"name": "Fusils d'Assaut Stalker-47",
		"type": "gun",
		"damage": 20,
		"fire_rate": 0.2,
		"magazine_size": 24,
		"reload_time": 2.5,
		"ammo_type": 200001,
		"range": 50,
		"is_automatic": false,
		"icon": null,
		"model": null,
		"speed": 800,
	}
}

func is_weapon(item_id: int) -> bool:
	return str(item_id).begins_with("1")
