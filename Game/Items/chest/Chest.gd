extends Node2D

var potion_scene = preload("res://Items/Potion.tscn")
var key_scene = preload("res://Items/Key.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var item_type = 1
#export var item_ammount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HitBox_area_entered(area):
	$Sprite.animation = "open"
	$Fade.play("New Anim")
	var new_item
	match(item_type):
		1:
			new_item = potion_scene.instance()
			new_item.big = false
			#potion_small
			pass
		2:
			new_item = potion_scene.instance()
			new_item.big = true
			#potion_big
			pass
		3:
			new_item = key_scene.instance()
			
			#key
			pass
		4:
			#item1
			pass
		5:
			#item2
			pass
	if(new_item!=null):
		new_item.global_position = global_position
		GM.current_level.add_child(new_item)
	$HitBox.queue_free()
	pass # Replace with function body.
