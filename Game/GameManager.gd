extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var battleViewScene = preload("res://Battle/Battle_View.tscn")

var current_level

var currentBattle

var playerHP = 6
var playerSTAM = 10

var inBattle = false

export var colorLogical = Color()
export var colorEmotion = Color()
export var colorLawful = Color()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func next_level():
	print("start next level")
	get_tree().change_scene("res://LEVELS/"+String(current_level.ID+1)+"/GameLevel.tscn")
	pass

func load_battle(enemyID):
	#get_tree().paused = true
	inBattle = true
	var newBattle = battleViewScene.instance()
	GM.current_level.add_child(newBattle)
	
	pass


func unload_battle():
	inBattle = false
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
