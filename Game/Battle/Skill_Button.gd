extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var bttnID = 0

var is_ready = true

var selected = Color("bcec82")
var open = Color("1bff6f")
var closed = Color("500101")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func toggle_border(skill_ready):
	if(skill_ready):
		$Border.color = open
		is_ready = true
	else:
		$Border.color = closed
		is_ready = false
	pass

func select_skill():
	GM.currentBattle.use_skill(bttnID)
	pass
	
func _on_Skill_Button_pressed():
	if(is_ready):
		select_skill()
	pass # Replace with function body.


func _on_Skill_Button_mouse_entered():
	if(is_ready):
		$Border.color = selected
	pass # Replace with function body.




func _on_Skill_Button_mouse_exited():
	if(is_ready):
		$Border.color = open
	pass # Replace with function body.
