extends Node2D

#		VARIABLE DEFINITION		#

#Movement
var move_speed = 320
var velocity = Vector2.ZERO

const sweep_speed = 600
var sweep_dir = 0

#Inputs
var lastDir = 1
var restraint_action = false

#State Machine
enum STATES{DEFAULT = 0, ATTACK = 1, SWEEP = 2, DAMAGE = 3}
var state = STATES.DEFAULT

#Timers
export var shootCD = 0.15
export var shootTime = 0.0
export var shootDecrease = 3.0

export var invencibleTime = 0.0
export var invencibleCD = 0.5
export var invencibleDecrease = 3.0

var sweep_time = 0.0
var sweep_set_time = 0.15

#Status
var maxLives = 5
var lives = maxLives
var power = 0.0

#Animation
var dir = 0
var inner_loops = {"Attack": 0}

#References
onready var spr = $Sprites/CHR
onready var damageBox = $Damage/Hitbox
onready var normalHitbox = load("res://NormalCharHitbox.tres")
onready var smallHitbox = load("res://SmallCharHitbox.tres")

var ofudaPath = "res://ofuda.tscn"

#		METHODS TOOLS		#
func flipImage(sprite):
	if (dir > 0):
		sprite.flip_h = false
	elif(dir < 0):
		sprite.flip_h = true
		
func AnimationEnd(sprite):
	if (sprite.frame == sprite.frames.get_frame_count(sprite.animation)-1):
		return true

# 		METHODS	REALTIME	#
#Input
func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		lastDir = sign(velocity.x)
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		lastDir = sign(velocity.x)
	
	#EXORCISM
	if Input.is_action_just_pressed("action_attack") and velocity.x == 0 and not restraint_action:
		if (state != STATES.ATTACK):
			state = STATES.ATTACK
			spr.animation = "Attack"
			$Rod/Hitbox/Animate.play("AttackHitbox0")
			$Rod/Hitbox.disabled = false
	
	#SWEEP			
	elif Input.is_action_just_pressed("action_attack") and velocity.x != 0 and not restraint_action:
		if (state != STATES.SWEEP):
			state = STATES.SWEEP
			spr.animation = "Sweep"
			
			$Feet/Hitbox.disabled = false
			sweep_time = sweep_set_time
			sweep_dir = dir
	#SHOOT
	if Input.is_action_just_pressed("action_shoot") and shootTime <= 0.0 and not restraint_action:
		var instance = load(ofudaPath)
		instance = instance.instance()
		get_parent().get_parent().add_child(instance)
		instance.global_position.x = global_position.x-4
		instance.global_position.y = global_position.y-12
		shootTime = shootCD
		
			
	if Input.is_action_just_pressed("debug_reset"):
		get_tree().reload_current_scene()
	velocity = velocity.normalized() * move_speed
	

func anim():
	if (dir == 0):
		spr.play("Idle") 
		spr.flip_h = false
	else:
		if dir < 0:
			spr.flip_h = true
		else:
			spr.flip_h = false
		spr.play("Walk")
		

func StateDefault(delta):
	position.x += velocity.x * delta
	anim()

func StateAttack(delta):
	restraint_action = true
	if (AnimationEnd(spr) and inner_loops["Attack"] == 0):
		spr.frame = 0
		spr.flip_h = not spr.flip_h
		inner_loops["Attack"] = 1
		$Rod/Hitbox/Animate.play("AttackHitbox1")
		
	if (inner_loops["Attack"] == 1 and AnimationEnd(spr)):
		inner_loops["Attack"] = 0
		state = STATES.DEFAULT
		restraint_action = false
		$Rod/Hitbox.disabled = true
	pass
	
func StateSweep(delta,sDir):
	$Damage/Hitbox.disabled = true
	flipImage(spr)
	if sDir == 0:
		sDir = lastDir
	
	$Feet/Hitbox.position.x = 13 * sDir
	restraint_action = true
	position.x += (sDir * sweep_speed) * delta
	
	if (sweep_time > 0):
		sweep_time -= 1.0 * delta
	else:
		state = STATES.DEFAULT
		restraint_action = false
		$Feet/Hitbox.disabled = true
		$Damage/Hitbox.disabled = false
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func StateDamage(delta):
	if (AnimationEnd(spr)):
		restraint_action = false
		damageBox.disabled = false
		$Sparks.visible = false
		state = STATES.DEFAULT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	dir = sign(velocity.x)
	
	if (shootTime > 0.0):
		shootTime -= shootDecrease * delta
		
	if (invencibleTime > 0.0):
		invencibleTime -= invencibleDecrease * delta
		damageBox.disabled = true
	else:
		damageBox.disabled = false
		$Animate.stop()
		modulate[3] = 1
		
	if (state == STATES.DEFAULT):
		StateDefault(delta)
	elif(state == STATES.ATTACK):
		StateAttack(delta)
	elif(state == STATES.SWEEP):
		StateSweep(delta,sweep_dir)
	elif(state == STATES.DAMAGE):
		StateDamage(delta)
		
	if not spr.playing:
		print("not playing")


# 		SIGNALS		# 

func _on_Rod_body_entered(body):
	if body.get_class() == "RigidBody2D":
		if body != null:
			var dir = sign(body.global_position.x - $Rod.global_position.x)
			body.linear_velocity = Vector2(0,0)
			body.apply_impulse(body.global_position -  $Rod.global_position ,Vector2(body.hImpulseAttack * dir,body.vImpulseShoot))
	pass # Replace with function body.


func _on_Damage_body_entered(body):
	if body.get_class() == "RigidBody2D":
		if body != null:
			spr.play("Damage")
			invencibleTime = invencibleCD
			restraint_action = true
			$Animate.play("DmgFlick")
			$Sparks/Animate.play("Default")
			$Sparks.visible = true
			state = STATES.DAMAGE
			lives -= 1

	pass # Replace with function body.


func _on_Feet_body_entered(body):
	if body.get_class() == "RigidBody2D":
		if body != null:
			var dir = sign(body.global_position.x - $Rod.global_position.x)
			body.linear_velocity = Vector2(0,0)
			body.apply_impulse(body.global_position -  $Rod.global_position ,Vector2(body.hImpulseAttack * dir,body.vImpulseShoot))
	pass # Replace with function body.
