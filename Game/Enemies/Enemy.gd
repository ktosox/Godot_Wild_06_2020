extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var type = 0
var enemy_types = {
	0 : "vamp",
	1 : "skull",
	2 : "skely",
	3 : "guard",
	4 : "dude" 
}


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Sprite.animation = enemy_types[randi()%enemy_types.size()]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HitBox_area_entered(area):
	print("START FIGHT")
	pass # Replace with function body.
