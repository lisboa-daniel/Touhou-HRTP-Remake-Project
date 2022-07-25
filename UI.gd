extends Control

class SpellCard extends Control:
	var tex = load("res://Sprites_Images/spell_card_slot.png")
	var item = null
	var position
	var width = self.tex.get_width()
	var height = self.tex.get_width()
	var id 
	func DrawSelf():
		width = self.tex.get_width()
		height = self.tex.get_width()
		draw_texture(tex, Vector2(position.x - width/2,position.y - height/2), Color(1,1,1,1))


#ref
var porra = 10
onready var chr = get_parent().get_node("Pixel/Character")
onready var heart = [load("res://Sprites_Images/hearts2.png"),load("res://Sprites_Images/hearts1.png")]
var maxLives =0
var lives = 0
var states = ["Default","Attack","Sweeping","Damage"]
var spellSlots = []

# Called when the node enters the scene tree for the first time.
func _ready():
	lives = chr.lives
	maxLives = chr.maxLives
	
	for i in range(3):
		var sc = SpellCard.new()
		sc.id = i
		sc.tex = load("res://Sprites_Images/spell_card_slot.png")
		sc.position = Vector2(68 + (sc.width+4) * i ,50)
		spellSlots.append(sc)
			
	pass # Replace with function body.

func draw_sprite(tex,position,blend,center=true):

	if (center):
		position.x -= tex.get_width()
		position.y -= tex.get_height()/2
		
	draw_texture(tex, position, blend)

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): 											
	var string = "state = %s\nrestraint action = %s" % [states[chr.state],  ("true" if chr.restraint_action else "false")]
	$Debug.text = string
	if(Input.is_action_just_pressed("action_attack")):
		porra -= 1

	if (lives != chr.lives):
		lives = chr.lives
		update()
	pass

func _draw():
	var c = 0
	while(c < len(spellSlots)):
		draw_sprite(spellSlots[c].tex,spellSlots[c].position,Color(1,1,1,1))
		c = c + 1
		
	for i in range(maxLives):
		draw_sprite(heart[0],Vector2(64 + 18 * i,20),Color(1,1,1,1))
		pass
		
	for i in range(lives):
		draw_sprite(heart[1],Vector2(64 + 18 * i,20),Color(1,1,1,1))
	
