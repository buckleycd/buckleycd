extends KinematicBody2D

onready var EffectScene = preload("res://Effects/EnemyDeathEffect/EnemyDeathEffect.tscn") 


enum {
	IDLE,
	WANDER,
	CHASE
}
export var acceleration = 300
export var max_speed = 50
export var friction = 200
export var damage = 1

var state = IDLE
var velocity = Vector2.ZERO

onready var animatedSprite = $AnimatedSprite
onready var playerDetectionZone = $PlayerDetectionZone
var player = null
onready var startingPosition = global_position

func _physics_process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO,friction * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			if playerDetectionZone.can_see_player():
				player = playerDetectionZone.player
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * max_speed,acceleration * delta)
				animatedSprite.flip_h = velocity.x < 0
			else:
				state = IDLE
				
	velocity = move_and_slide(velocity)
	
func return_to_start(delta):
	var direction = (startingPosition - global_position).normalized()
	velocity = velocity.move_toward(direction * max_speed,acceleration * delta)
	animatedSprite.flip_h = velocity.x < 0

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
	
func _on_Stats_no_health():
	var effectInstance = EffectScene.instance()
	effectInstance.global_position = global_position
	get_parent().add_child(effectInstance)
	queue_free()
