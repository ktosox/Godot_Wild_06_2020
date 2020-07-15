extends RigidBody2D

var follow_mouse = false


func _physics_process(delta):
	if(follow_mouse):
		var target =  get_global_mouse_position()-global_position
		if(target.length()>50):
			self.apply_central_impulse(target * (300/target.length_squared())  )
		else:
			self.apply_central_impulse(target.clamped(30))

func _input(event):
	
	if(event.is_action_pressed("ui_accept")):
		follow_mouse = false



func _on_RigidBody2D_mouse_entered():
	follow_mouse = true
	pass # Replace with function body.


