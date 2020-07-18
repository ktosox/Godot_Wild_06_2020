extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var item_type = 0
export var item_ammount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HitBox_area_entered(area):
	$Sprite.animation = "open"
	$Fade.play("New Anim")
	match(item_type):
		1:
			pass
		2:
			pass
		3:
			pass
	pass # Replace with function body.
