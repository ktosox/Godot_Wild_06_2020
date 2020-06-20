extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var skillPool # an array of all skill IDs

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

var allSkillIDs = range(1,8)

onready var enemy_stamina = 4 + randi()%5
onready var enemy_morale = 40 + 10 * (randi()%4)

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
	$TimerSkillResolve.start()

	pass

func use_skill(bttn):
	
	textField.append_bbcode("skill with ID "+String(skill_map[bttn])+ " used by Player,")

	if(textField.get_line_count()>6):
		textField.remove_line(0)
	reroll_button(bttn)
	
	enemy_turn()
	pass

func use_convience():
	end_battle()
	#enemy_turn()
	#check enemy morale
	#if sucess -> end_battle()
	#if fail ->  enemy_turn()

	pass

func update_button(bttn):
	var trgt_bttn = button_map[bttn]
	trgt_bttn.texture_normal = load("res://Battle/Icons/"+String(skill_map[bttn])+".png")
	trgt_bttn.toggle_border(true)
	pass

func reroll_button(bttn):
	var trgt_bttn = button_map[bttn]
	var possible_skills = allSkillIDs.duplicate()
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
		enemy_stamina += 1
		enemy_stam_bar.value = enemy_stamina
		pass
	else:
		random_skill += 10
		enemy_stamina -= 1
		enemy_stam_bar.value = enemy_stamina
		#make a stamina attack
		pass
		

	
	textField.append_bbcode("skill with ID "+String(random_skill)+ " used by Enemy")
	textField.newline()
	if(textField.get_line_count()>6):
		textField.remove_line(0)
	player_turn()
	pass

func update_HP():
	pass


func _on_TimerEnemyAttack_timeout():
	enemy_attack()
	pass # Replace with function body.


func _on_Convince_pressed():
	use_convience()
	pass # Replace with function body.


func _on_Options_pressed():
	pass # Replace with function body.


func _on_TimerSkillResolve_timeout():
	match randi()%2:
		0:
			textField.append_bbcode(" it was super persuasive!")
		1:
			textField.append_bbcode(" it wasn't very persuasive.")
	textField.newline()
	if(textField.get_line_count()>6):
		textField.remove_line(0)
	$TimerEnemyAttack.start()
	
	pass # Replace with function body.
