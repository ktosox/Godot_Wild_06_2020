extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var battleViewScene = preload("res://Battle/Battle_View.tscn")

var current_level
var currentPlayer
var currentBattle

var playerHP = 100
var playerHPMax = 100
var playerSTAM = 10
var playerSTAMMax = 10

var SUPPORT = 0

var inBattle = false

export var colorLogical = Color()
export var colorEmotion = Color()
export var colorLawful = Color()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func next_level():
	print("start next level")
	if(current_level == null):
		get_tree().change_scene("res://LEVELS/1/GameLevel.tscn")
	else:
		
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

func set_player_HP(change):
	playerHP += change
	if playerHP > playerHPMax :
		playerHP = playerHPMax
	pass
func set_player_STAM(change):
	playerSTAM += playerSTAM
	if playerSTAM > playerSTAMMax :
		playerSTAM = playerSTAMMax

func update_support(newSup):
	SUPPORT += newSup
	currentPlayer.set_support(SUPPORT)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
