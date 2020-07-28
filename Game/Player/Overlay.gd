extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Item1 = $Screen/Top/Background/HBoxContainer/Panel1/Item1/Ammount
onready var Item2 = $Screen/Top/Background/HBoxContainer/Panel2/Item2/Ammount
onready var Level = $Screen/Top/Background/HBoxContainer/Panel4/Level/Ammount
onready var Followers = $Screen/Top/Background/HBoxContainer/Panel3/Followers/Ammount
var optionsWindowScene = preload("res://OptionsMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if(GM.current_level != null):
		Level.text = String(GM.current_level.ID)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_support(ammount):
	Followers.text = String(ammount)
	pass


func set_item(which,ammount):
	if(which==1):
		Item1.text = String(ammount)
	if(which==2):
		Item2.text = String(ammount)
	pass

func _on_Options_pressed():
	var optionsMEnu = optionsWindowScene.instance()
	add_child(optionsMEnu)
	pass # Replace with function body.


func _on_Debug2_pressed():
	GM.update_item(1,1)
	pass # Replace with function body.


func _on_Debug_pressed():
	GM.update_item(1,-1)
	pass # Replace with function body.
