extends Node

#health system
export(int) var max_health = 1
onready var health = max_health setget set_health
## we will want a healthbar or something
export(int) var speed = 100


#spell system
export(int) var max_mana = 1
onready var current_mana = max_mana
#maybe implement a stamina system for special attacks or spells that use physical health

signal no_health

func set_health(value):
	health = clamp(value,0,max_health)
	if health == 0:
		emit_signal("no_health")
