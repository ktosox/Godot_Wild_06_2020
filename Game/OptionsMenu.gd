extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sound.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	$Music.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	$Effects.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sounds"))
	get_tree().paused = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().paused = false
	self.queue_free()
	pass # Replace with function body.


func _on_Sound_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master") ,value)
	pass # Replace with function body.


func _on_Music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music") ,value)
	pass # Replace with function body.


func _on_Effects_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds") ,value)
	pass # Replace with function body.
