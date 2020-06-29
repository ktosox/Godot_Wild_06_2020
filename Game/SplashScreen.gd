extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var optionsWindowScene = preload("res://OptionsMenu.tscn")

var av1 = load("res://Battle/Avatars/skeleton_05.png")
var av2 = load("res://Battle/Avatars/skeleton_06.png")
var av3 = load("res://Battle/Avatars/skeleton_07.png")


# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	GM.skelyPool.erase(GM.playerAvatar)
	GM.next_level()
	pass # Replace with function body.


func _on_Button2_pressed():
	var optionsMEnu = optionsWindowScene.instance()
	add_child(optionsMEnu)
	pass # Replace with function body.


func _on_Button3_pressed():
	match GM.playerAvatar :
		av1:
			$TextureRect.texture = av2
			GM.playerAvatar = av2
			pass
		av2:
			$TextureRect.texture = av3
			GM.playerAvatar = av3
			pass
		av3:
			$TextureRect.texture = av1
			GM.playerAvatar = av1
			pass
	pass # Replace with function body.
