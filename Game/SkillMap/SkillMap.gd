extends Node

	#1-8 player / 11-15 Blue / 16-20 Red / 21-25 Green / 26-30 Black
var skillIDs = {

}

func _ready():
	load_skills()
	pass

func load_skills():
	var path = "res://JSONs/fight_skills.json"
	var file = File.new()
	if not file.file_exists(path):
		print("no file to load fight skills")
		return
	
	file.open(path,file.READ)
	
	var text = file.get_as_text()
	
	var result = (parse_json(text))
	for t in result:
		
		skillIDs[int(t)] = result[t].duplicate()#[int(t)]=result[t].duplicate()

	file.close()
	pass

func get_skill(ID):
	if(skillIDs.keys().has(ID)):
		return skillIDs[ID]
	pass
