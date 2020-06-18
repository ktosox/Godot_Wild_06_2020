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

var allSkillIDs = [1,2,3]

var button_map = {
	1 : bttn1,
	2 : bttn2,
	3 : bttn3,
	4 : bttn4
}

var skill_map = {
	1 : 0,
	2 : 0,
	3 : 0,
	4 : 0
}

# Called when the node enters the scene tree for the first time.
func _ready():

	load_battle()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func load_battle():
	#set avatars
	#roll skills
	for i in [1,2,3,4]:
		reroll_button(i)
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
	$VBoxContainer/ButtonSpace/ButtonBlocker.visible = false
	pass

func enemy_turn():
	$VBoxContainer/ButtonSpace/ButtonBlocker.visible = true
	pass

func use_skill(ID,player=true):
	#use skill of ID 
	#if player is true -> the player is using the skill
	pass

func update_button(bttn):
	pass

func reroll_button(bttn):
	
	update_button(bttn)
	pass

func enemy_attack():
	pass


func _on_Button_pressed():
	end_battle()
	pass # Replace with function body.
