extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var title = "Lorem Ipsum"

export var avatar : Texture # if texture is placed here then ovveride the defualt texture
export var type = 5

export var HP = 100

export var conviction = 69

var enemy_data ={

}

var enemy_types = {
	0 : "vamp",
	1 : "skull",
	2 : "skely",
	3 : "guard",
	4 : "dude" 
}


# Called when the node enters the scene tree for the first time.
func _ready():
	update_type()
	pass # Replace with function body.


func update_type():
	if(!enemy_types.has(type)):
		randomize()
		type = randi()%enemy_types.size()
	$Sprite.animation = enemy_types[type]
	if(avatar == null ):
		match type:
			0:
				avatar = GM.vampPool[randi()%GM.vampPool.size()]
			1:
				avatar = GM.skullPool[randi()%GM.skullPool.size()]
			2:
				avatar = GM.skelyPool[randi()%GM.skelyPool.size()]
			3:
				avatar = GM.guardPool[randi()%GM.guardPool.size()]
			4:
				avatar = GM.dudePool[randi()%GM.dudePool.size()]
	enemy_data["type"] = type
	enemy_data["HP"] = HP
	enemy_data["tittle"] = title
	enemy_data["avatar"] = avatar
	enemy_data["conviction"] = conviction



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HitBox_area_entered(area):
	$HitBox/CollisionShape2D.queue_free()
	print(enemy_data)
	GM.load_battle(enemy_data)
	print("START FIGHT")
	pass # Replace with function body.
