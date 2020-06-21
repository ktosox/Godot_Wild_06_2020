extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


onready var avatarPlayer = $VBoxContainer/ActorSpace/Player

onready var avatarEnemy = $VBoxContainer/ActorSpace/Enemy

onready var bttn1 = $VBoxContainer/ButtonSpace/Skill_Button1
onready var bttn2 = $VBoxContainer/ButtonSpace/Skill_Button2
onready var bttn3 = $VBoxContainer/ButtonSpace/Skill_Button3
onready var bttn4 = $VBoxContainer/ButtonSpace/Skill_Button4

onready var player_stam_bar = $VBoxContainer/BarSpace/PlayerStamin
onready var player_hp_bar = $VBoxContainer/BarSpace/PlayerHP
onready var enemy_stam_bar = $VBoxContainer/BarSpace/EnemyStamina
onready var enemy_hp_bar = $VBoxContainer/BarSpace/EnemyHP


onready var textField = $VBoxContainer/ButtonSpace/RichTextLabel

var skillPoolTop = range(1,11)
var skillPoolBot = range(11,21)

var allSkillTable = {
 1 : ["Appeal to Emotion","HINT",1,0,-6,0,0] ,
 2 : ["Appeal to Authority","HINT",2,0,-6,0,0] ,
 3 : ["Use Facts And Logic","HINT",3,0,-6,0,0] ,
 4 : ["Listen Carefully","HINT",0,4,0,1,0] ,
 5 : ["Distract Your Opponent","HINT",0,2,0,1,-1] ,
 6 : ["Suggest a Middle Ground","HINT",0,2,-2,1,0] ,
 7 : ["Throw a Punchy One-Liner","HINT",0,2,0,2,0] ,
 8 : ["Ask a Loaded Question","HINT",0,0,-4,0,-1] ,
 9 : ["Ask a lot of questions","HINT",0,0,-2,0,-2] ,
 10 : ["Reject the Status Quo","HINT",0,0,-4,1,0] ,
 11 : ["Suggest a Slippery Slope","HINT",0,2,-8,-1,0] ,
 12 : ["Point out an ad hominem","HINT",2,2,-4,-1,-2] ,
 13 : ["Humiliate The Opposition","HINT",1,0,-8,-1,-1] ,
 14 : ["Shift The Burden Of Proof","HINT",2,4,-6,-1,0] ,
 15 : ["Set Up a Straw Man","HINT",0,0,0,-1,0] ,
 16 : ["Shift the goal post","HINT",3,2,-6,-1,-1] ,
 17 : ["Imply causation through correlation","HINT",0,4,-4,-1,-1] ,
 18 : ["Pull Of a Texas Sharpshooter","HINT",3,0,-10,-1,0] ,
 19 : ["Invoke Anecdotal Arguments","HINT",0,4,-2,-1,-2] ,
 20 : ["Make a Provocative Statement","HINT",1,2,-6,-1,-1] ,
}

onready var enemy_stamina = 1 + randi()%2
onready var enemy_morale = 40 + 10 * (randi()%4)
onready var enemy_type = randi()%4

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
	print(skillPoolTop)
	print(skillPoolBot)

	player_turn()
	
	pass # Replace with function body.


func load_battle():
	GM.currentBattle = self
	player_hp_bar.value = GM.playerHP

	player_stam_bar.value = GM.playerSTAM
	enemy_hp_bar.value = enemy_morale
	enemy_stam_bar.value = enemy_stamina
	#set avatars
	
	button_map[1] = bttn1
	button_map[2] = bttn2
	button_map[3] = bttn3
	button_map[4] = bttn4
	for z in range(4):
		reroll_button(z+1)
		pass
	$Curatin/Animator.play("rise")
	$VBoxContainer/ButtonSpace/ButtonBlocker.visible = false
	
	pass

func end_battle():
	$Curatin/Animator.play("lower")
	pass

func close_battleview():
	GM.unload_battle()
	self.queue_free()
	pass

func player_turn():
	#unlock skill buttons
	$TurnInd.color = Color(0,1,0)
	$VBoxContainer/ButtonSpace/ButtonBlocker.visible = false
	pass

func enemy_turn():
	$VBoxContainer/ButtonSpace/ButtonBlocker.visible = true
	$TurnInd.color = Color(1,0,0)
	$TimerEnemyAttack.start()
	pass

func use_skill(bttn):
	var skill = allSkillTable[ skill_map[bttn] ]
	textField.append_bbcode("You "+skill[0]+", ")
	if(textField.get_line_count()>6):
		textField.remove_line(0)
	if(skill[4]<0):
		print("deal "+String(skill[4])+" dmg to enemy")
		enemy_morale += skill[4]
		if(enemy_morale<0):
			enemy_defeat()
		enemy_hp_bar.value = enemy_morale
	if(skill[3]>0):
		print("heal player for "+String(skill[3]))
		GM.set_player_HP(skill[3])
		player_hp_bar.value = GM.playerHP
	if(skill[5]!=0):
		print("change player stamina by ",String(skill[5]))
		GM.set_player_STAM(skill[5])
		player_stam_bar.value = GM.playerSTAM
	if(skill[6]!=0):
		print("change enemy stamina by ",String(skill[6]))
		enemy_stamina+=skill[6]
		enemy_stam_bar.value = enemy_stamina
	reroll_button(bttn)
	if(enemy_type == skill[2]):
		textField.append_bbcode(" it was super persuasive!")
	else:
		textField.append_bbcode(" it kinda worked.")
	textField.newline()
	if(textField.get_line_count()>6):
		textField.remove_line(0)
	enemy_turn()
	pass

func use_convience():
	if(enemy_morale<19+randi()%9):
		player_victory()
	else:
		textField.append_bbcode("Your opponent is not convinced")
		textField.newline()
		if(textField.get_line_count()>6):
			textField.remove_line(0)
	enemy_turn()

	pass

func update_button(bttn):
	var trgt_bttn = button_map[bttn]
	var skill_data = allSkillTable[skill_map[bttn]]
	trgt_bttn.texture_normal = load("res://Battle/Icons/"+String(skill_map[bttn])+".png")
	trgt_bttn.toggle_border(true)
	trgt_bttn.hint_tooltip = skill_data[0] +  '\n' + skill_data[1] 
	pass

func reroll_button(bttn):
	var trgt_bttn = button_map[bttn]
	var possible_skills
	match bttn:
		1:
			possible_skills = skillPoolTop.duplicate()
		2:
			possible_skills = skillPoolTop.duplicate()
		3:
			possible_skills = skillPoolBot.duplicate()
		4:
			possible_skills = skillPoolBot.duplicate()
	for t in skill_map.values():
		possible_skills.erase(t)
	randomize()

	skill_map[bttn] = possible_skills[randi()%possible_skills.size()]

	update_button(bttn)
	pass

func enemy_attack():
	#pick an attack
	var random_skill = 1 + randi()%10
	if(enemy_stamina - (1+randi()%10) )< 0:
		#make a non stamina attack
		pass
	else:
		random_skill += 10
		#make a stamina attack
		pass
	var skill = allSkillTable[random_skill]
		
	if(skill[4]<0):
		GM.set_player_HP(skill[4])
		player_hp_bar.value = GM.playerHP
		if(GM.playerHP<0):
			player_defeat()
	print("dmg player for "+String(skill[4]))
	if(skill[3]>0):
		print("enemy heals self for "+String(skill[3]))
		enemy_morale += skill[3]

		enemy_hp_bar.value = enemy_morale
	if(skill[6]!=0):
		print("change player stamina by ",String(skill[6]))
		GM.set_player_STAM(skill[6])
		player_stam_bar.value = GM.playerSTAM
	if(skill[5]!=0):
		print("change enemy stamina by ",String(skill[5]))
		enemy_stamina+=skill[5]
		enemy_stam_bar.value = enemy_stamina
	
	textField.append_bbcode("The enemy decided to "+skill[0])
	textField.newline()
	if(textField.get_line_count()>6):
		textField.remove_line(0)
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


func _on_Convince_pressed():
	use_convience()
	pass # Replace with function body.


func _on_Options_pressed():
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
