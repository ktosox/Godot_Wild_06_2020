extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var ID = 0
var IdToImage = {
	10 : "res://Battle/Avatars/skeleton_01.png",
	11 : "res://Battle/Avatars/skeleton_04.png",
	20 : "res://Battle/Avatars/dark_knight_04.png"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	set_avatar()
	pass # Replace with function body.

func set_avatar():
	var new_avatar
	if(ID==0):
		randomize()
		var stuff = IdToImage.keys()
		new_avatar =  IdToImage[stuff[randi()%IdToImage.size()] ]
	else:
		new_avatar = IdToImage[ID]
	texture = load(new_avatar)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
