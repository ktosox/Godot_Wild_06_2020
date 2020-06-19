extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var follow = false
var target 
var resting_pos = Vector2(0,-7)
var speed = 1.8

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (follow):
		global_position += ( ( target.global_position + resting_pos ) - global_position ) * delta * speed
	pass

func get_used():
	self.queue_free()
	pass

func _on_HitBox_area_entered(area):
	if(!follow):
		target = area.get_parent()
		print("target set")
		follow = true
		$HitBox/CollisionShape2D.disabled = true
	pass # Replace with function body.
