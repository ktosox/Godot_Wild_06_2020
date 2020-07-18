extends Node


var battleViewScene = preload("res://Battle/Battle_View.tscn")

var creditsScene = "res://Credits.tscn"


var vampPool = [load("res://Battle/Avatars/addons_097.png"),load("res://Battle/Avatars/ancient_vampire.png"),load("res://Battle/Avatars/banshee.png")]
var skullPool = [load("res://Battle/Avatars/joker_01.png"),load("res://Battle/Avatars/joker_02.png")]
var skelyPool = [load("res://Battle/Avatars/skeleton_03.png"),load("res://Battle/Avatars/skeleton_07.png"),load("res://Battle/Avatars/skeleton_05.png"),load("res://Battle/Avatars/skeleton_06.png")]
var guardPool = [load("res://Battle/Avatars/goblin_02.png"),load("res://Battle/Avatars/troll_01.png"),load("res://Battle/Avatars/orc_02.png")]



#Key references used by multiple scenes
var current_level 
var currentPlayer
var currentBattle
var battleCallerData

#Player data
var playerSkillUpgrades=[false,false,false,false]
var playerHP = 100
var playerHPMax = 100
var playerAvatar = load("res://Battle/Avatars/skeleton_07.png")
var SUPPORT = 0
var inBattle = false
var items = [0,0]#ammount of item1 and item2


#These need to be updated to match the new color scheme
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

func load_battle(enemy_data):
	#get_tree().paused = true
	battleCallerData = enemy_data
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
	currentBattle = null
	pass

func set_player_HP(change):
	playerHP += change
	if playerHP > playerHPMax :
		playerHP = playerHPMax
	currentPlayer.update_HP(playerHP)
	if(currentBattle != null ):
		currentBattle.player_hp_bar.value = playerHP
	pass

func update_support(newSup):
	SUPPORT += newSup
	if(currentPlayer!=null):
		currentPlayer.get_node("Overlay").set_support(SUPPORT)
	pass

func update_item(which,ammount):
	if (which == 1 or which ==2):
		items[which]+=ammount
		
		currentPlayer.get_node("Overlay").set_item(which,items[which])
	pass
	
func get_item(which):
	if (which == 1 or which ==2):
		return items[which]
	pass

func _on_DungeonMusic_finished():
	$DungeonMusic.play()
	pass # Replace with function body.
	
func win_game():
	get_tree().change_scene(creditsScene)
	pass


