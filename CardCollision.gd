extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var flip = false
onready var point = load("res://UI/point.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if (not flip):
		var ins = point.instance()
		add_child(ins)
		ins.get_node("Animate").play("Fadeout")
		ins.get_node("Label").text = "+" + str(100)
		$Sprite.play("RedFlip")
		flip = true
	
	pass # Replace with function body.
