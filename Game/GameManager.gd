extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var battleViewScene = preload("res://Battle/Battle_View.tscn")

var creditsScene = "res://Credits.tscn"


var vampPool = [load("res://Battle/Avatars/addons_097.png"),load("res://Battle/Avatars/ancient_vampire.png"),load("res://Battle/Avatars/banshee.png")]
var skullPool = [load("res://Battle/Avatars/joker_01.png"),load("res://Battle/Avatars/joker_02.png")]
var skelyPool = [load("res://Battle/Avatars/skeleton_03.png"),load("res://Battle/Avatars/skeleton_07.png"),load("res://Battle/Avatars/skeleton_05.png"),load("res://Battle/Avatars/skeleton_06.png")]
var guardPool = [load("res://Battle/Avatars/dark_knight_04.png"),load("res://Battle/Avatars/living_armor_01.png"),load("res://Battle/Avatars/living_armor_03.png")]
var dudePool = [load("res://Battle/Avatars/goblin_02.png"),load("res://Battle/Avatars/troll_01.png"),load("res://Battle/Avatars/orc_02.png")]

var playerSkillUpgrades=[false,false,false,false]


var current_level 
var currentPlayer
var currentBattle

var playerHP = 100
var playerHPMax = 100
var playerAvatar = load("res://Battle/Avatars/skeleton_07.png")
var SUPPORT = 0

var inBattle = false

var battleCallerData

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

func load_battle(enemy):
	#get_tree().paused = true
	battleCallerData = enemy
	$DungeonMusic/Manager.play("Stop")
	$BattleMusic.play()
	inBattle = true
	var newBattle = battleViewScene.instance()
	GM.current_level.add_child(newBattle)
	
	pass


func unload_battle():
	inBattle = false
	$BattleMusic.stop()
	$DungeonMusic/Manager.play("Start")
	pass

func set_player_HP(change):
	playerHP += change
	if playerHP > playerHPMax :
		playerHP = playerHPMax
	currentPlayer.update_HP(playerHP)
	pass

func update_support(newSup):
	SUPPORT += newSup
	if(currentPlayer!=null):
		currentPlayer.set_support(SUPPORT)
	pass




func _on_DungeonMusic_finished():
	$DungeonMusic.play()
	pass # Replace with function body.
	
func win_game():
	get_tree().change_scene(creditsScene)
	pass


