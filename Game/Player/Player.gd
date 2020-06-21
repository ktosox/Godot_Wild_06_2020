extends Path2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var optionsWindowScene = preload("res://OptionsMenu.tscn")

var speed = 40
export var moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	GM.currentPlayer = self
	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("LMB"):
		reset_path(get_local_mouse_position())


func reset_path(target):
	if(GM.inBattle):
		return
	curve.clear_points()
	if(get_parent().has_method("path_from_2_points")):
		var path = get_parent().path_from_2_points($Location.global_position,get_global_mouse_position())
		for pnt in range(path.size()):
			curve.add_point(path[pnt])
		if($Location.global_position.x -get_global_mouse_position().x >0):
			$Location/AnimatedSprite.scale.x=-1
		else:
			$Location/AnimatedSprite.scale.x=1
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
		if(GM.inBattle):
			moving = false
			$Location/StepSound.playing = false
			$AnimationPlayer.stop()
			return
		$Location.offset+= delta * speed
		if(!$Location/StepSound.playing):
			$Location/StepSound.play()
		if($Location.unit_offset==1 or curve.get_baked_length()<0.01):
			moving = false
			$Location/StepSound.playing = false
			$AnimationPlayer.stop()
	pass
	


func _on_TimerMouseCheck_timeout():
	if(Input.is_action_pressed("LMB")):
		reset_path(get_local_mouse_position())
	pass # Replace with function body.

func set_support(newSup):
	$Overlay/Support.value = newSup
	pass


func _on_Button_pressed():
	var optionsMEnu = optionsWindowScene.instance()
	add_child(optionsMEnu)
	pass # Replace with function body.
