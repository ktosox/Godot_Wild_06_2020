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
	$Curatin/Animator.play("rise")
	$VBoxContainer/ButtonSpace/ButtonBlocker.visible = false
	pass

func end_battle():
	$Curatin/Animator.play("lower")
	pass

func close_battleview():
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

func reroll_button(bttn):
	pass

func enemy_attack():
	pass
