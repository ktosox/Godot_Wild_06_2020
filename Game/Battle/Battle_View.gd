extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var skillPool # an array of all skill IDs

onready var avatarPlayer = $VBoxContainer/ActorSpace/Player

onready var avatarEnemy = $VBoxContainer/ActorSpace/Enemy

# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func load_battle():
	#set avatars
	#roll skills
	pass

func player_turn():
	#unlock skill buttons
	pass

func enemy_turn():
	
	pass

func use_skill(ID,player=true):
	#use skill of ID 
	#if player is true -> the player is suing the skill
	pass

func enemy_attack():
	pass
