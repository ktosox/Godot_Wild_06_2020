extends CanvasLayer


var optionsWindowScene = preload("res://OptionsMenu.tscn")

onready var avatarPlayer = $VBoxContainer/ActorSpace/Player

onready var avatarEnemy = $VBoxContainer/ActorSpace/Enemy

onready var bttn1 = $VBoxContainer/ButtonSpace/Skill_Button1
onready var bttn2 = $VBoxContainer/ButtonSpace/Skill_Button2
onready var bttn3 = $VBoxContainer/ButtonSpace/Skill_Button3
onready var bttn4 = $VBoxContainer/ButtonSpace/Skill_Button4


onready var chaos_bar = $VBoxContainer/BarSpace/VBoxContainer/ChaosBar
onready var convince_bar = $VBoxContainer/BarSpace/VBoxContainer/ConvinceBar

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

var enemySkillCooldowns = {1:0,2:0,3:0,4:0,5:0} # keeps the cooldown state for enemy skills

onready var textField = $VBoxContainer/ButtonSpace/RichTextLabel

export var dialogSkills ={
	1: ["Pos",3,2,0,1,-1],
	2: ["/pride [PH]",3,1,2,-1,-1],
	3: ["er",3,0,-1,1,-3],
	4: ["Copment",3,1,2,1,-1],
	5: ["Address bad living conditions",6,1,1,2,-1],
	6: ["Tell him, he deserves better than this",6,1,1,2,-1],
	7: ["Tell him, current dungeon master doesnt deserve his services",6,2,0,0,-3],
	8: ["Complain how dungeon master isnt taking care of his employees",6,1,0,1,-3],
	9: ["Tell how you would improve it",2,0,1,0,-1],
	10:["Give him nice decoration to his room",0,0,0,0,0],
	11:["Convince him to join you [PH]",0,0,0,0,0],
	12:["Promise high position in new dungeon order",0,0,0,0,0],
	13:["Try to bribe him with one of your items",0,0,0,0,0]
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
	load_dialog_skills()
	randomize()
	load_battle()

	
	pass # Replace with function body.
	
func load_dialog_skills():
	var path = "res://JSONs/dialog_skills.json"
	var file = File.new()
	if not file.file_exists(path):
		print("no file to load dialog skills")
		return
	
	file.open(path,file.READ)
	
	var text = file.get_as_text()
	
	var result = (parse_json(text))
	for t in result:
		dialogSkills[int(t)]=result[t].duplicate()
	
	file.close()


func load_battle():
	GM.currentBattle = self
	player_hp_bar.value = GM.playerHP
	enemy_hp_bar.value = GM.battleCallerData["HP"]
	player_hp_bar.visible = false
	enemy_hp_bar.visible = false
	avatarPlayer.texture = GM.playerAvatar
	avatarEnemy.texture = GM.battleCallerData["avatar"]
	convince_bar.value = GM.battleCallerData["conviction"]
	
	
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
		print(skill_data)
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

		match playerStatus[0]:
			1:
				print("poison 1")
			2:
				print("poison 2")
			3:
				print("poison 3")
			4:
				print("stun")
			
		playerStatus[1]-=1
		if(playerStatus[1]<1):
			playerStatus.clear()

	#unlock skill buttons
	$TurnInd.color = Color(0,1,0)
	$VBoxContainer/ButtonSpace/ButtonBlocker.visible = false
	pass

func enemy_turn():
	#tick cooldowns
	for z in [1,2,3,4,5] :
		if(enemySkillCooldowns[z] > 0):
			enemySkillCooldowns[z]-=1

	
	if(enemyStatus.size()>0):

		match enemyStatus[0]:
			1:
				print("poison 1")
			2:
				print("poison 2")
			3:
				print("poison 3")
			4:
				print("stun")
			
		enemyStatus[1]-=1
		if(enemyStatus[1]<1):
			enemyStatus.clear()
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
	add_text("You use " + selected_skill["Name"])
	#print(selected_skill)
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
	if(selected_skill["StatusType"]!=0):
		enemyStatus=[int(selected_skill["StatusType"]),int(selected_skill["StatusTurns"])]
	if(selected_skill["PlayerMod"]!=0):
		playerMod = int(selected_skill["PlayerMod"])
	if(selected_skill["EnemyMod"]!=0):
		enemyMod = int(selected_skill["EnemyMod"])
	# if base_dmg > 0 then deal base_dmg+modifier to enemy HP
	# else skip dealing dmg
	



	enemy_turn()
	pass


#func update_button(bttn):
#	var trgt_bttn = button_map[bttn]
#
##	trgt_bttn.texture_normal = load("res://Battle/Icons/"+String(skill_map[bttn])+".png")
##	trgt_bttn.toggle_border(true)
##	trgt_bttn.hint_tooltip = skill_data[0] +  '\n' + skill_data[1] 
#	pass

func enemy_attack():
	#pick an attack
	var skill_pool = [1,2,3,4,5]
	for z in [1,2,3,4,5] :
		if enemySkillCooldowns[z] > 0 :
			skill_pool.erase(z)
	var base_dmg = 0
	var skillID = skill_pool[randi()%skill_pool.size()]

	var selected_skill = SM.get_skill(5 +( GM.battleCallerData["type"]*5 )+skillID)
	add_text("The enemy used "+selected_skill["Name"])
	if (selected_skill["Cooldown"]!=0):
		enemySkillCooldowns[skillID] = selected_skill["Cooldown"]

	base_dmg+=selected_skill["Damange"]
#	print("enemy dmg is: ",base_dmg)
	if(base_dmg!=0):
		base_dmg+=enemyMod
		enemyMod=0
		GM.set_player_HP(-base_dmg)
	if(selected_skill["StatusType"]!=0):
		playerStatus=[selected_skill["StatusType"],selected_skill["StatusTurns"]]
	if(selected_skill["PlayerMod"]!=0):
		playerMod = selected_skill["PlayerMod"]
	if(selected_skill["EnemyMod"]!=0):
		enemyMod = selected_skill["EnemyMod"]





		
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
		complete_negotiation(bttn)
		negociate_step2(bttn)
	elif(current_step==2):
		chaos_bar.value+=2
		match bttn:
			1:
				match(negotiation_branch):
					1:
						complete_negotiation(6)
						pass
					2:
						complete_negotiation(6)
						pass
					3:
						complete_negotiation(7)
						pass
					4:
						complete_negotiation(5)
						pass
				#do math
				
				negociate_step3(bttn)
				pass
			2:
				match(negotiation_branch):
					1:
						complete_negotiation(5)
						pass
					2:
						complete_negotiation(7)
						pass
					3:
						complete_negotiation(8)
						pass
					4:
						complete_negotiation(8)
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
								complete_negotiation(5)
							2:
								complete_negotiation(6)
								pass
					2:
						match(negotiation_sub_branch):
							1:
								complete_negotiation(5)
							2:
								complete_negotiation(8)
					3:
						match(negotiation_sub_branch):
							1:
								complete_negotiation(8)
							2:
								complete_negotiation(5)
					4:
						match(negotiation_sub_branch):
							1:
								complete_negotiation(8)
							2:
								complete_negotiation(7)
				negociate_step4(bttn)
				pass
			2:
				match(negotiation_branch):
					1:
						match(negotiation_sub_branch):
							1:
								complete_negotiation(7)
							2:
								complete_negotiation(8)
					2:
						match(negotiation_sub_branch):
							1:
								complete_negotiation(7)
							2:
								complete_negotiation(6)
					3:
						match(negotiation_sub_branch):
							1:
								complete_negotiation(6)
							2:
								complete_negotiation(7)
					4:
						match(negotiation_sub_branch):
							1:
								complete_negotiation(6)
							2:
								complete_negotiation(5)
				negociate_step4(bttn)
				pass
			3:
				#do math
				complete_negotiation(9)
				negociate_step1()
				pass
	elif(current_step==4):
		chaos_bar.value+=1
		#do math
		complete_negotiation(9)
		negociate_step1()
	pass

func add_text(text):
	textField.newline()
	textField.append_bbcode(String(text) )
	if(textField.get_line_count()>15):
		textField.remove_line(0)

	pass

func complete_negotiation(selection):
	convince_bar.value+=dialogSkills[selection][1]+dialogSkills[selection][enemy_type+2]
	add_text(dialogSkills[selection][0])
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
