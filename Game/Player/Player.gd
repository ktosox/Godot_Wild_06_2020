extends Path2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 40
export var moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("LMB"):
		reset_path(get_local_mouse_position())


func reset_path(target):
	curve.clear_points()
	if(get_parent().has_method("path_from_2_points")):
		var path = get_parent().path_from_2_points($Location.global_position,get_global_mouse_position())
		for pnt in range(path.size()):
			curve.add_point(path[pnt])
	else:
		curve.add_point($Location.position)
		curve.add_point(target)
	$Line2D.clear_points()
	for i in curve.get_baked_points():
		$Line2D.add_point(i)

	$AnimationPlayer.play("loop")
	moving = true
	$Location.unit_offset = 0
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (moving):
		$Location.offset+= delta * speed
		if($Location.unit_offset==1):
			moving = false
			$AnimationPlayer.stop()
	pass
