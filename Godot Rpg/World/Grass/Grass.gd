extends Node2D
var EffectScene = preload("res://Effects/GrassEffect/GrassEffect.tscn") 

func grass_effect():
	var effectInstance = EffectScene.instance()
	effectInstance.global_position = global_position
	get_parent().add_child(effectInstance)

func _on_Hurtbox_area_entered(_area):
	grass_effect()
	queue_free()
