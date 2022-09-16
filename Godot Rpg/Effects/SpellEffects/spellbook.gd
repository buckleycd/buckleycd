extends Node

#reference in other code as follows
#var spell = load("res://Effects/SpellEffects/spellbook.gd").new()
# calling flare spell - spell.flare(target)
# calling heal spell - spell.heal(target)

#load effects here
const flare_scene = preload("res://Effects/SpellEffects/FlareEffect.tscn")
signal spell_animation_finished

## Start Spellbook
func flare(target):
	var effectInstance = flare_scene.instance()
	effectInstance.global_position = target.position
	var main = target.get_parent()
	main.add_child(effectInstance)
	effectInstance.connect("animation_finished",target,"magic_animation_finished")
	return -4 #hp damage

## Flame
## Fireball
## Inferno

## heal1
## heal2
## heal3

## cure
## cure2
## cure3

## poison
## poison2
## poison3

## wind
## wind2
## wind3

## ice
## ice2
## ice3
