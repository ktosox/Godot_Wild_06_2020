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

var allSkillIDs = range(1,8)

var button_map = {}

var skill_map = {
	1 : 0,
	2 : 0,
	3 : 0,
	4 : 0
}


# Called when the node enters the scene tree for the first time.
func _ready():
	load_battle()
	GM.currentBattle = self
	button_map[1] = bttn1
	button_map[2] = bttn2
	button_map[3] = bttn3
	button_map[4] = bttn4
	for z in range(4):
		reroll_button(z+1)
		pass
	player_turn()
	pass # Replace with function body.


func load_battle():
	#set avatars
	#roll skills
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

func use_skill(bttn,player=true):
	var who 
	if(player):
		who = "player"
	else:
		who = "enemy"
	print("skill with ID "+String(skill_map[bttn])+ " used by "+who)
	#use skill of ID 
	#if player is true -> the player is using the skill
	reroll_button(bttn)
	enemy_turn()
	pass

func update_button(bttn):
	var trgt_bttn = button_map[bttn]
	trgt_bttn.texture_normal = load("res://Battle/Icons/SpellBook"+String(skill_map[bttn])+".png")
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
	print("enemy skill used")
	player_turn()
	pass



func _on_Button3_pressed():
	end_battle()
	pass # Replace with function body.


func _on_TimerEnemyAttack_timeout():
	enemy_attack()
	pass # Replace with function body.
