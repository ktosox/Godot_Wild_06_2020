extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func accept_key():
	var tile1 = Vector2(round( (global_position.x)/16 ) -1,round(global_position.y - 8) / 16 )
	var tile2 = Vector2(round( (global_position.x)/16 ),round(global_position.y - 8) / 16 )
	#print( round(global_position.y - 8) / 16 )
	GM.current_level.open_door(tile1,tile2)
	$Sprite.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DetectionRange_area_entered(area):
	area.get_parent().get_used()
	accept_key()
	pass # Replace with function body.
