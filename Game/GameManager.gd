extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_level

var playerHP = 6
var playerSTAM = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func next_level():
	print("start next level")
	get_tree().change_scene("res://LEVELS/"+String(current_level.ID+1)+"/GameLevel.tscn")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass