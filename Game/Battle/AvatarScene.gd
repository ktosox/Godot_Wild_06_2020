extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var ID = 0

#	0 : "vamp",
#	1 : "skull",
#	2 : "skely",
#	3 : "guard",
#	4 : "dude" 
# Called when the node enters the scene tree for the first time.
func _ready():
	set_avatar()
	pass # Replace with function body.

func set_avatar():
	if(ID==0):
		match GM.playerAvatar:
			2:
				texture = load("res://Battle/Avatars/skeleton_05.png")
			3:
				texture = load("res://Battle/Avatars/skeleton_06.png")
			1:
				texture = load("res://Battle/Avatars/skeleton_07.png")

	else:
		match ID:
			0:
				texture = GM.vampPool[randi()%GM.vampPool.size()]
				pass
			1:
				texture = GM.skullPool[randi()%GM.skullPool.size()]
				pass
			2:
				texture = GM.skelyPool[randi()%GM.skelyPool.size()]
				pass
			3:
				texture = GM.guardPool[randi()%GM.guardPool.size()]
				pass
			4:
				texture = GM.dudePool[randi()%GM.dudePool.size()]
				pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
