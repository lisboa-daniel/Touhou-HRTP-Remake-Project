extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var save =  Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	save = translation
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	##translate(Vector3(0,0,-3 * delta))
#	pass
