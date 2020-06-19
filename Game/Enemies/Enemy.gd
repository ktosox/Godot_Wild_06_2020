extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var type = 5
var enemy_types = {
	0 : "vamp",
	1 : "skull",
	2 : "skely",
	3 : "guard",
	4 : "dude" 
}


# Called when the node enters the scene tree for the first time.
func _ready():
	if(!enemy_types.has(type)):
		randomize()
		type = randi()%enemy_types.size()
	$Sprite.animation = enemy_types[type]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HitBox_area_entered(area):
	$HitBox/CollisionShape2D.queue_free()
	GM.load_battle(type)
	print("START FIGHT")
	pass # Replace with function body.
