extends Navigation2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func path_from_2_points(start,end):
#		$start.global_position = $PathFinder.get_closest_point($Player.get_current_poistion())
#		var target = get_global_mouse_position()
#		#print(target)
#		$click.global_position = target
#		target = $PathFinder.get_closest_point(target)
#		#print(target)
#		$end.global_position = target
	start = get_closest_point(start)
	end = get_closest_point(end)
#		$Player.move(path)
	return get_simple_path(start,end,true)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
