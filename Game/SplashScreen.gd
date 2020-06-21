extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var optionsWindowScene = preload("res://OptionsMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	GM.next_level()
	pass # Replace with function body.


func _on_Button2_pressed():
	var optionsMEnu = optionsWindowScene.instance()
	add_child(optionsMEnu)
	pass # Replace with function body.
