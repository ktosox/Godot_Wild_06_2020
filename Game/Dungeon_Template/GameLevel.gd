extends Navigation2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var ID = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
func _enter_tree():
	GM.current_level = self

func path_from_2_points(start,end):
	start = get_closest_point(start)
	end = get_closest_point(end)
	return get_simple_path(start,end,true)

func open_door(location1, location2):
	$Floors.set_cellv(location1,3)
	$Floors.set_cellv(location2,3)
	
	$Floors.update_bitmask_region(location1+Vector2(-1,-1),location2+Vector2(1,1))
	$Floors.update()
	$Floors.call_deferred("update_dirty_quadrants")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	GM.win_game()
	pass # Replace with function body.
