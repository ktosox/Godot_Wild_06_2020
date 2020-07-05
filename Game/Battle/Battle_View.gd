extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var optionsWindowScene = preload("res://OptionsMenu.tscn")

onready var avatarPlayer = $VBoxContainer/ActorSpace/Player

onready var avatarEnemy = $VBoxContainer/ActorSpace/Enemy

onready var bttn1 = $VBoxContainer/ButtonSpace/Skill_Button1
onready var bttn2 = $VBoxContainer/ButtonSpace/Skill_Button2
onready var bttn3 = $VBoxContainer/ButtonSpace/Skill_Button3
onready var bttn4 = $VBoxContainer/ButtonSpace/Skill_Button4


onready var chaos_bar = $VBoxContainer/BarSpace/ChaosBar
onready var convince_bar = $VBoxContainer/BarSpace/ConvinceBar

onready var player_hp_bar = $VBoxContainer/BarSpace/PlayerHP

onready var enemy_hp_bar = $VBoxContainer/BarSpace/EnemyHP

var in_negotiation = true
var current_step = 1
var negotiation_branch = 0

var playerMod = 0
var enemyMod = 0

var playerStatus = {}
var enemyStatus = {}

onready var textField = $VBoxContainer/ButtonSpace/RichTextLabel


onready var enemy_type = randi()%4

var enemySkills = []



var button_map = {}

var skill_map = {
	1 : 0,
	2 : 0,
	3 : 0,
	4 : 0
}


# Called when the node enters the scene tree for the first time.
func _ready():

	randomize()
	load_battle()

	
	pass # Replace with function body.


func load_battle():
	GM.currentBattle = self
	player_hp_bar.value = GM.playerHP
#	enemy_hp_bar.value = get value from relevant spot
	player_hp_bar.visible = false
	enemy_hp_bar.visible = false
	avatarPlayer.texture = GM.playerAvatar
	#avatarEnemy.texture = GM.battleCallerData["avatar"]
	
	button_map[1] = bttn1
	button_map[2] = bttn2
	button_map[3] = bttn3
	button_map[4] = bttn4
	
	#set convince and chaos bars
	
	$Curatin/Animator.play("rise")
	$VBoxContainer/ButtonSpace/ButtonBlocker.visible = false
	negociate_step1()
	pass

func start_fight():
	
	#switch interface to fight from negotiations
	in_negotiation = false
	player_hp_bar.visible = true
	enemy_hp_bar.visible = true
	chaos_bar.visible = false
	convince_bar.visible = false
	$VBoxContainer/ButtonSpace/StartFight.queue_free()
	player_turn()
	pass

func end_battle():
	$Curatin/Animator.play("lower")
	pass

func close_battleview():
	GM.unload_battle()
	self.queue_free()
	pass

func player_turn():
	#tick CDs
	for b in [1,2,3,4] :
		if(button_map[b].CD >0):
			button_map[b].CD -=1
			if(button_map[b].CD == 0):
				button_map[b].toggle_border(true)
	#check status effects
	if(playerStatus.size()>0):
		print("player has a ststus effect!")
		#match that deals with statuses goes here

	#unlock skill buttons
	$TurnInd.color = Color(0,1,0)
	$VBoxContainer/ButtonSpace/ButtonBlocker.visible = false
	pass

func enemy_turn():
	#tick CDs

	if(enemyStatus.size()>0):
		print("enemy has a ststus effect!")
		#match that deals with statuses goes here
	$VBoxContainer/ButtonSpace/ButtonBlocker.visible = true
	$TurnInd.color = Color(1,0,0)
	$TimerEnemyAttack.start()
	pass

func use_skill(bttn):
	
	if(in_negotiation):
		progress_negotiation(bttn)
		return
	
	var base_dmg = 0
	match bttn:
		1:
			pass
		2:
			pass
		3:
			pass
		4:
			pass
	
	# if base_dmg > 0 then deal base_dmg+modifier to enemy HP
	# else skip dealing dmg
	
#	textField.append_bbcode("You "+skill[0]+", ")
#	if(textField.get_line_count()>6):
#		textField.remove_line(0)
#	textField.newline()


	enemy_turn()
	pass


func update_button(bttn):
	var trgt_bttn = button_map[bttn]

#	trgt_bttn.texture_normal = load("res://Battle/Icons/"+String(skill_map[bttn])+".png")
#	trgt_bttn.toggle_border(true)
#	trgt_bttn.hint_tooltip = skill_data[0] +  '\n' + skill_data[1] 
	pass

func negociate_step1():
	current_step = 1
	print("current phase 1")
	#load buttons 
	button_map[1].toggle_border(true)
	button_map[2].toggle_border(true)
	button_map[3].toggle_border(true)
	button_map[4].toggle_border(true)
	pass
	
func negociate_step2(selection):
	negotiation_branch = selection
	current_step = 2
	print("current phase 2")
	button_map[4].toggle_border(false)
	#load buttons 
	pass
func negociate_step3(selection):
	current_step = 3
	#load buttons 
	print("current phase 3")
	pass
func negociate_step4(selection):
	current_step = 4
	print("current phase 4")
	#load buttons 
	button_map[2].toggle_border(false)
	button_map[3].toggle_border(false)
	pass

func progress_negotiation(bttn):
	if(current_step==1):
		match bttn:
			1:
				#do math
				pass
			2:
				#do math
				pass
			3:
				#do math
				pass
			4:
				#do math
				pass
		negociate_step2(bttn)
	elif(current_step==2):
		match bttn:
			1:
				#do math
				negociate_step3(bttn)
				pass
			2:
				#do math
				negociate_step3(bttn)
				pass
			3:
				#do math
				#remove resource
				negociate_step1()
				pass
	elif(current_step==3):
		match bttn:
			1:
				#do math
				negociate_step4(bttn)
				pass
			2:
				#do math
				negociate_step4(bttn)
				pass
			3:
				#do math
				negociate_step1()
				pass
	elif(current_step==4):
		#do math
		negociate_step1()
	pass

func enemy_attack():
	#pick an attack
	var random_skill = 1 + randi()%10

		
#	if(skill[4]<0):
#		GM.set_player_HP(skill[4])
#		
#		if(GM.playerHP<0):
#			player_defeat()
#	print("dmg player for "+String(skill[4]))
#	if(skill[3]>0):
#		print("enemy heals self for "+String(skill[3]))
#		enemy_morale += skill[3]
#
#		enemy_hp_bar.value = enemy_morale

	#player_hp_bar.value = GM.playerHP
	
#	textField.append_bbcode("The enemy decided to "+skill[0])
#	textField.newline()
#	if(textField.get_line_count()>6):
#		textField.remove_line(0)
	player_turn()
	pass

func player_defeat():

	$EndScreen.visible = true
	$EndScreen/PlayerDies.visible = true
	get_tree().paused = true
	pass

func enemy_defeat():

	$EndScreen.visible = true
	$EndScreen/EnemyDies.visible = true
	get_tree().paused = true
	pass

func player_victory():

	GM.update_support(15+randi()%6)
	$EndScreen.visible = true
	$EndScreen/PlayerVictory.visible = true
	get_tree().paused = true
	pass

func _on_TimerEnemyAttack_timeout():
	enemy_attack()
	pass # Replace with function body.



func _on_Options_pressed():
	var optionsMEnu = optionsWindowScene.instance()
	add_child(optionsMEnu)
	pass # Replace with function body.


func _on_ButtonPlayerVictory_pressed():
	get_tree().paused = false
	end_battle()
	pass # Replace with function body.


func _on_ButtonPlayerDies_pressed():
	get_tree().paused = false
	pass # Replace with function body.


func _on_ButtonEnemyDies_pressed():
	get_tree().paused = false
	end_battle()
	pass # Replace with function body.


func _on_StartFight_pressed():
	start_fight()
	pass # Replace with function body.
