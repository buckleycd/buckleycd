extends "res://Enemies/Enemy.gd"

const FRICTION = 200
const KNOCKBACK_VELOCITY = 120
var knockback = Vector2.ZERO

onready var stats = $Stats
onready var hurtbox = $Hurtbox

func _ready():
	damage = 1
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO,FRICTION * delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * KNOCKBACK_VELOCITY
	hurtbox.start_invincibility(0.2)
	hurtbox.create_hit_effect()

