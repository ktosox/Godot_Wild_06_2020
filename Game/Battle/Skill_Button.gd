extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var ID = 0

export var skill_ready = true

var selected = Color("bcec82")
var open = Color("1bff6f")
var closed = Color("500101")


# Called when the node enters the scene tree for the first time.
func _ready():
	toggle_border()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func toggle_border():
	if(skill_ready):
		$Border.color = open
	else:
		$Border.color = closed
	pass

func select_skill():
	print("skill selected")
	pass
	
func _on_Skill_Button_pressed():
	if(skill_ready):
		select_skill()
	pass # Replace with function body.

func re_roll_skill():
	pass

func _on_Skill_Button_mouse_entered():
	if(skill_ready):
		$Border.color = selected
	pass # Replace with function body.


func _on_Skill_Button_mouse_exited():
	toggle_border()
	pass # Replace with function body.
