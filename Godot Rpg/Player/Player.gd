extends KinematicBody2D

# Movement and speed
export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 150
export var FRICTION = 500
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

#State management
enum stateEnum {
	MOVE,
	ROLL,
	ATTACK,
	MAGIC
}
var state = stateEnum.MOVE

#Sprite Animation
onready var animator = $AnimationTree
onready var animationState = animator.get("parameters/playback") 
onready var weaponHitbox = $WeaponPivot/WeaponHitbox
onready var hurtbox = $Hurtbox
#TODO: Implement magic
onready var spell = load("res://Effects/SpellEffects/spellbook.gd").new()

var stats = PlayerStats

##########################################
func _ready():
	stats.connect("no_health",self,"queue_free")
	animator.active = true
	weaponHitbox.knockback_vector = roll_vector
	
###########################################

func _physics_process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
	
	match state:
		stateEnum.MOVE:
			state_move(delta)
		stateEnum.ROLL:
			state_roll(delta)
		stateEnum.ATTACK:
			state_attack(delta)
		stateEnum.MAGIC:
			state_magic(delta)
		

#########################################

func animate_move(input_vector):
	animator.set("parameters/Idle/blend_position",input_vector)
	animator.set("parameters/Run/blend_position",input_vector)
	animator.set("parameters/Attack/blend_position",input_vector)
	animator.set("parameters/Roll/blend_position",input_vector)
	
	animationState.travel("Run")
	


##########################################	
func state_move(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector=input_vector
		weaponHitbox.knockback_vector = roll_vector
		animate_move(input_vector)
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO,FRICTION * delta)
		
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = stateEnum.ATTACK
	elif Input.is_action_just_pressed("roll"):
		state = stateEnum.ROLL
	elif Input.is_action_just_pressed("magic"):
		state = stateEnum.MAGIC	

########################################
func state_roll(delta):	
	velocity = velocity.move_toward(roll_vector * ROLL_SPEED,ROLL_SPEED * delta)
	animationState.travel("Roll")
	move()
	
func roll_animation_finished():
	velocity = velocity * .8 #keeps from sliding too much
	state = stateEnum.MOVE

func move():
	velocity = move_and_slide(velocity)
		
#######################################
func state_attack(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
func attack_animation_finished():
	state = stateEnum.MOVE
	
##############################
func state_magic(_delta):
	velocity = Vector2.ZERO
	spell.flare(self)
	
func magic_animation_finished():
	state = stateEnum.MOVE
	


func _on_Hurtbox_area_entered(area):
	if area.damage:
		stats.health -= area.damage
	else:
		stats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
	print(stats.health)
