extends Node

	#1-8 player / 11-15 Blue / 16-20 Red / 21-25 Green / 26-30 Black
onready var skillIDs = {
	1:$Player.skill1,
	2:$Player.skill2,
	3:$Player.skill3,
	4:$Player.skill4,
	5:$Player.skill1plus,
	6:$Player.skill2plus,
	7:$Player.skill3plus,
	8:$Player.skill4plus,
	11:$EnemyBlue.skill1,
	12:$EnemyBlue.skill2,
	13:$EnemyBlue.skill3,
	14:$EnemyBlue.skill4,
	15:$EnemyBlue.skill5,
	16:$EnemyRed.skill1,
	17:$EnemyRed.skill2,
	18:$EnemyRed.skill3,
	19:$EnemyRed.skill4,
	20:$EnemyRed.skill5,
	21:$EnemyGreen.skill1,
	22:$EnemyGreen.skill2,
	23:$EnemyGreen.skill3,
	24:$EnemyGreen.skill4,
	25:$EnemyGreen.skill5,
	26:$EnemyBlack.skill1,
	27:$EnemyBlack.skill2,
	28:$EnemyBlack.skill3,
	29:$EnemyBlack.skill4,
	30:$EnemyBlack.skill5,
}

func get_skill(ID):
	if(skillIDs.keys().has(ID)):
		return skillIDs[ID]
	pass
