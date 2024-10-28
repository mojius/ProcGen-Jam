extends Node2D


	
func _ready():
	var max_height = 300
	var cave_prefab = preload("res://prefabs/Cave.tscn")
	var prev_cave = [-max_height / 2, max_height / 2, 0]
	GameManager.level_layer = $Level
	for i in 3:
		var cave = cave_prefab.instance()
		cave.position.x = cave.length * i
		GameManager.level_layer.add_child(cave)
		prev_cave = cave.make_cave(prev_cave)
	GameManager.player_layer = $Player
	GameManager.enemy_layer = $Enemies
	GameManager.player_projectile_layer = $PlayerProjectiles
	GameManager.enemy_projectile_layer = $EnemyProjectiles
