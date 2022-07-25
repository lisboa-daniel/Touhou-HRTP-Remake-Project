extends RigidBody2D

export var vImpulseShoot = -400.0
export var hImpulseShoot = 100.0

export var vImpulseAttack = -400.0
export var hImpulseAttack = 300.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var chr = get_parent().get_node("Character/Rod/Hitbox")
var chrid = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	chrid = chr.get_instance_id()
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		linear_velocity = Vector2(0,0)
		apply_impulse(Vector2(16,0),Vector2(0,-300))
	
