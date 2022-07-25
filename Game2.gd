extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tex = $Viewport.get_texture()
	$Sprite.texture = tex
	
	var tex2 = $Viewport2.get_texture()
	$Sprite3.texture = tex2
	pass
