extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func accept_key():
	var tile1 = Vector2(int(global_position.x - 8) / 16 , int( (global_position.y)/16 ) -1)
	var tile2 = Vector2(int(global_position.x - 8) / 16 , int( (global_position.y)/16 ))
	#MY EYES, THE SPAGHET IS BURNING MY EYES

	print(tile1,tile2)
	GM.current_level.open_door(tile1,tile2)
	$Sprite.visible = false
	$AudioStreamPlayer2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DetectionRange_area_entered(area):
	area.get_parent().get_used()
	$DetectionRange/CollisionShape2D.queue_free()
	accept_key()
	pass # Replace with function body.
