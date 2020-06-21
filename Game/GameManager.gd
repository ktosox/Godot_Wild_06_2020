extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var battleViewScene = preload("res://Battle/Battle_View.tscn")

var allDungeonMusic = []

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
	$DungeonMusic/Manager.play("Start")
	if(current_level == null):
		get_tree().change_scene("res://LEVELS/1/GameLevel.tscn")
	else:
		
		get_tree().change_scene("res://LEVELS/"+String(current_level.ID+1)+"/GameLevel.tscn")
	pass

func load_battle(enemyID):
	#get_tree().paused = true
	$DungeonMusic/Manager.play("Stop")
	$BattleMusic.play()
	inBattle = true
	var newBattle = battleViewScene.instance()
	GM.current_level.add_child(newBattle)
	
	pass


func unload_battle():
	inBattle = false
	$DungeonMusic/Manager.play("Start")
	$BattleMusic.stop()
	pass

func set_player_HP(change):
	playerHP += change
	if playerHP > playerHPMax :
		playerHP = playerHPMax
	pass
func set_player_STAM(change):
	playerSTAM += change
	if playerSTAM > playerSTAMMax :
		playerSTAM = playerSTAMMax

func update_support(newSup):
	SUPPORT += newSup
	if(currentPlayer!=null):
		currentPlayer.set_support(SUPPORT)
	pass




func _on_DungeonMusic_finished():
	$DungeonMusic.play()
	pass # Replace with function body.


func _on_BattleMusic_finished():
	$BattleMusic.play()
	pass # Replace with function body.
