extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var health = true
export var big = true

var small_health = Vector2(128,144)
var big_health = Vector2(144,128)
var small_stamina = Vector2(112,128)
var big_stamina = Vector2(112,144)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$PickUp.playback_speed += randf()*3
	if (health) :
		if(big):
			$Sprite.region_rect = Rect2(big_health, Vector2(16,16) )
		else:
			$Sprite.region_rect = Rect2(small_health, Vector2(16,16) )
	else:
		if(big):
			$Sprite.region_rect = Rect2(big_stamina, Vector2(16,16) )
		else:
			$Sprite.region_rect = Rect2(small_stamina, Vector2(16,16) )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HitBox_area_entered(area):
	$PickUp.play("New Anim")
	pass # Replace with function body.
