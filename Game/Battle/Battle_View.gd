extends CanvasLayer


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
var negotiation_sub_branch = 0

var playerMod = 0
var enemyMod = 0

var playerStatus = [] #status ID followed by time in turns
var enemyStatus = []

onready var textField = $VBoxContainer/ButtonSpace/RichTextLabel

export var dialogSkills ={
	1: ["Point out how bad dungeon looks",3,2,0,1,-1],
	2: ["Try to address monster honor/pride [PH]",3,1,2,-1,-1],
	3: ["Badmouth current dungeon master",3,0,-1,1,-3],
	4: ["Complain about low quality equipment",3,1,2,1,-1],
	5: ["Address bad living conditions",6,1,1,2,-1],
	6: ["Tell him, he deserves better than this",6,1,1,2,-1],
	7: ["Tell him, current dungeon master doesnt deserve his services",6,2,0,0,-3],
	8: ["Complain how dungeon master isnt taking care of his employees",6,1,0,1,-3],
	9: ["Tell how you would improve it",2,0,1,0,-1],
}


onready var enemy_type = randi()%4


var enemySkills = []
var allEnemySkills = []

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
	enemy_hp_bar.value = GM.battleCallerData["HP"]
	player_hp_bar.visible = false
	enemy_hp_bar.visible = false
	avatarPlayer.texture = GM.playerAvatar
	avatarEnemy.texture = GM.battleCallerData["avatar"]
	
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
	load_player_skills()
	player_turn()
	pass

func load_player_skills():
	button_map[1].toggle_border(true)
	button_map[2].toggle_border(true)
	button_map[3].toggle_border(true)
	button_map[4].toggle_border(true)
	var skill_data 
	for s in [1,2,3,4]:
		if(GM.playerSkillUpgrades[s-1]):
			skill_map[s] = s+4
		else:
			skill_map[s] = s
		skill_data = SM.get_skill(skill_map[s])
		button_map[s].hint_tooltip = skill_data["Name"]+'\n'+skill_data["Tooltip"]
#	trgt_bttn.hint_tooltip = skill_data[0] +  '\n' + skill_data[1] 
	#set textures
	#set names and tooltips
	
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
	var selected_skill = SM.get_skill(skill_map[bttn])
	print(selected_skill)
	if (selected_skill["Cooldown"]!=0):
		button_map[bttn].CD = selected_skill["Cooldown"]
		button_map[bttn].toggle_border(false)
	base_dmg+=selected_skill["Damange"]
	if(base_dmg!=0):
		base_dmg+=playerMod
		playerMod=0
		enemy_hp_bar.value-=base_dmg
		if(enemy_hp_bar.value<=0):
			enemy_defeat()
	enemyStatus=[selected_skill["StatusType"],selected_skill["StatusTurns"]]
	if(selected_skill["PlayerMod"]!=0):
		playerMod = selected_skill["PlayerMod"]
	if(selected_skill["EnemyMod"]!=0):
		enemyMod = selected_skill["EnemyMod"]
	# if base_dmg > 0 then deal base_dmg+modifier to enemy HP
	# else skip dealing dmg
	
#	textField.append_bbcode("You "+skill[0]+", ")
#	if(textField.get_line_count()>6):
#		textField.remove_line(0)
#	textField.newline()


	enemy_turn()
	pass


#func update_button(bttn):
#	var trgt_bttn = button_map[bttn]
#
##	trgt_bttn.texture_normal = load("res://Battle/Icons/"+String(skill_map[bttn])+".png")
##	trgt_bttn.toggle_border(true)
##	trgt_bttn.hint_tooltip = skill_data[0] +  '\n' + skill_data[1] 
#	pass

func negociate_step1():
	current_step = 1
	print("current phase 1")
	#load buttons 
	button_map[1].toggle_border(true)
	button_map[1].hint_tooltip = dialogSkills[1][0]
	button_map[2].toggle_border(true)
	button_map[2].hint_tooltip = dialogSkills[2][0]
	button_map[3].toggle_border(true)
	button_map[3].hint_tooltip = dialogSkills[3][0]
	button_map[4].toggle_border(true)
	button_map[4].hint_tooltip = dialogSkills[4][0]
	pass
func negociate_step2(selection):
	negotiation_branch = selection
	current_step = 2
	match(selection):
		1:
			button_map[1].hint_tooltip = dialogSkills[6][0]
			button_map[2].hint_tooltip = dialogSkills[5][0]
			button_map[3].hint_tooltip = "Give him nice decoration to his room"
		2:
			button_map[1].hint_tooltip = dialogSkills[6][0]
			button_map[2].hint_tooltip = dialogSkills[7][0]
			button_map[3].hint_tooltip = "Convince him to join you [PH]"
		3:
			button_map[1].hint_tooltip = dialogSkills[7][0]
			button_map[2].hint_tooltip = dialogSkills[8][0]
			button_map[3].hint_tooltip = "Promise high position in new dungeon order"
		4:
			button_map[1].hint_tooltip = dialogSkills[5][0]
			button_map[2].hint_tooltip = dialogSkills[8][0]
			button_map[3].hint_tooltip = "Try to bribe him with one of your items"

	print("current phase 2")
	button_map[4].toggle_border(false)
	button_map[4].hint_tooltip = ""
	#load buttons 
	pass
func negociate_step3(selection):
	negotiation_sub_branch = selection
	match negotiation_branch:
		1:
			match(selection):
				1:
					button_map[1].hint_tooltip = "Address bad living conditions"
					button_map[2].hint_tooltip = "Tell him, current dungeon master doesnt deserve his services"
				2:
					button_map[1].hint_tooltip = "Tell him, he deserves better than this"
					button_map[2].hint_tooltip = "Complain how dungeon master isnt taking care of his employees"
		2:
			match(selection):
				1:
					button_map[1].hint_tooltip = "Address bad living conditions"
					button_map[2].hint_tooltip = "Tell him, current dungeon master doesnt deserve his services"
				2:
					button_map[1].hint_tooltip = "Complain how dungeon master isnt taking care of his employees"
					button_map[2].hint_tooltip = "Tell him, he deserves better than this"
		3:
			match(selection):
				1:
					button_map[1].hint_tooltip = "Complain how dungeon master isnt taking care of his employees"
					button_map[2].hint_tooltip = "Tell him, current dungeon master doesnt deserve his services"
				2:
					button_map[1].hint_tooltip = "Address bad living conditions"
					button_map[2].hint_tooltip = "Tell him, current dungeon master doesnt deserve his services"
		4:
			match(selection):
				1:
					button_map[1].hint_tooltip = "Complain how dungeon master isnt taking care of his employees"
					button_map[2].hint_tooltip = "Tell him, he deserves better than this"
				2:
					button_map[1].hint_tooltip = "Tell him, current dungeon master doesnt deserve his services"
					button_map[2].hint_tooltip = "Address bad living conditions"
	current_step = 3
	#load buttons 
	button_map[3].hint_tooltip = "Tell how you would improve it"
	print("current phase 3")
	pass
func negociate_step4(selection):
	current_step = 4
	print("current phase 4")
	button_map[1].hint_tooltip = "Tell how you would improve it"
	#load buttons 
	button_map[2].toggle_border(false)
	button_map[2].hint_tooltip = ""
	button_map[3].toggle_border(false)
	button_map[3].hint_tooltip = ""
	pass

func progress_negotiation(bttn):
	if(current_step==1):
		chaos_bar.value+=2
		convince_bar.value+=dialogSkills[bttn][1]+dialogSkills[bttn][2+randi()%4]
		negociate_step2(bttn)
	elif(current_step==2):
		chaos_bar.value+=2
		match bttn:
			1:
				match(negotiation_branch):
					1:
						convince_bar.value+=dialogSkills[6][1]+dialogSkills[6][2+randi()%4]
						pass
					2:
						convince_bar.value+=dialogSkills[6][1]+dialogSkills[6][2+randi()%4]
						pass
					3:
						convince_bar.value+=dialogSkills[7][1]+dialogSkills[7][2+randi()%4]
						pass
					4:
						convince_bar.value+=dialogSkills[5][1]+dialogSkills[5][2+randi()%4]
						pass
				#do math
				
				negociate_step3(bttn)
				pass
			2:
				match(negotiation_branch):
					1:
						convince_bar.value+=dialogSkills[5][1]+dialogSkills[5][2+randi()%4]
						pass
					2:
						convince_bar.value+=dialogSkills[7][1]+dialogSkills[7][2+randi()%4]
						pass
					3:
						convince_bar.value+=dialogSkills[8][1]+dialogSkills[8][2+randi()%4]
						pass
					4:
						convince_bar.value+=dialogSkills[8][1]+dialogSkills[8][2+randi()%4]
						pass

				negociate_step3(bttn)
				pass
			3:
				#do math
				#remove resource
				negociate_step1()
				pass
	elif(current_step==3):
		chaos_bar.value+=1
		match bttn:
			1:
				match(negotiation_branch):
					1:
						match(negotiation_sub_branch):
							1:
								convince_bar.value+=dialogSkills[5][1]+dialogSkills[5][2+randi()%4]
							2:
								convince_bar.value+=dialogSkills[6][1]+dialogSkills[6][2+randi()%4]
								pass
					2:
						match(negotiation_sub_branch):
							1:
								convince_bar.value+=dialogSkills[5][1]+dialogSkills[5][2+randi()%4]
							2:
								convince_bar.value+=dialogSkills[8][1]+dialogSkills[8][2+randi()%4]
					3:
						match(negotiation_sub_branch):
							1:
								convince_bar.value+=dialogSkills[8][1]+dialogSkills[8][2+randi()%4]
							2:
								convince_bar.value+=dialogSkills[5][1]+dialogSkills[5][2+randi()%4]
					4:
						match(negotiation_sub_branch):
							1:
								convince_bar.value+=dialogSkills[8][1]+dialogSkills[8][2+randi()%4]
							2:
								convince_bar.value+=dialogSkills[7][1]+dialogSkills[7][2+randi()%4]
				negociate_step4(bttn)
				pass
			2:
				match(negotiation_branch):
					1:
						match(negotiation_sub_branch):
							1:
								convince_bar.value+=dialogSkills[7][1]+dialogSkills[7][2+randi()%4]
							2:
								convince_bar.value+=dialogSkills[8][1]+dialogSkills[8][2+randi()%4]
					2:
						match(negotiation_sub_branch):
							1:
								convince_bar.value+=dialogSkills[7][1]+dialogSkills[7][2+randi()%4]
							2:
								convince_bar.value+=dialogSkills[6][1]+dialogSkills[6][2+randi()%4]
					3:
						match(negotiation_sub_branch):
							1:
								convince_bar.value+=dialogSkills[6][1]+dialogSkills[6][2+randi()%4]
							2:
								convince_bar.value+=dialogSkills[7][1]+dialogSkills[7][2+randi()%4]
					4:
						match(negotiation_sub_branch):
							1:
								convince_bar.value+=dialogSkills[6][1]+dialogSkills[6][2+randi()%4]
							2:
								convince_bar.value+=dialogSkills[5][1]+dialogSkills[5][2+randi()%4]
				negociate_step4(bttn)
				pass
			3:
				#do math
				convince_bar.value+=dialogSkills[9][1]+dialogSkills[9][2+randi()%4]
				negociate_step1()
				pass
	elif(current_step==4):
		chaos_bar.value+=1
		#do math
		convince_bar.value+=dialogSkills[9][1]+dialogSkills[9][2+randi()%4]
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
