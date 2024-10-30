extends Node2D


export var scroll_speed := 50.0
var cave_length = 2048
var cave_prefab = preload("res://prefabs/Cave.tscn")
var last_cave = null
var next_cave = null
var prev_cave = []
var player = null
var enemy_mover = null

func _ready():
	var max_height = 500	
	prev_cave = [-max_height / 2, max_height / 2, 0]
	GameManager.level_layer = $Level
	
	last_cave = cave_prefab.instance()
	last_cave.position.x = -cave_length
	GameManager.level_layer.add_child(last_cave)
	prev_cave = last_cave.make_cave(prev_cave)

	player = GameManager.spawn_player()
	player.get_node("Player").position.y = (prev_cave[0]+prev_cave[1])/2
	
	next_cave = cave_prefab.instance()
	next_cave.position.x = 0
	GameManager.level_layer.add_child(next_cave)
	prev_cave = next_cave.make_cave(prev_cave)
	
	GameManager.player_layer = $Player
	GameManager.enemy_layer = $Enemies
	GameManager.player_projectile_layer = $PlayerProjectiles
	GameManager.enemy_projectile_layer = $EnemyProjectiles
	
	spawn_some_enemies()
	
func spawn_some_enemies():
	var enemy = preload("res://prefabs/EnemyBoss1.tscn").instance()
	enemy.position.x = 450
	add_child(enemy)
	enemy_mover = enemy

func _process(delta):
	last_cave.position.x -= scroll_speed * delta
	next_cave.position.x -= scroll_speed * delta
	if next_cave.position.x < cave_length * -0.5:
		last_cave.queue_free()
		last_cave = next_cave
		next_cave = cave_prefab.instance()
		next_cave.position.x = last_cave.position.x + cave_length
		GameManager.level_layer.add_child(next_cave)
		prev_cave = next_cave.make_cave(prev_cave)
	$PlayAreaMargins.position.y = player.get_node("Player").position.y
	
	if enemy_mover:
		var cave_position = 1024*0.5 - next_cave.position.x - 1024*0.125
		var y0 = null
		var y1 = null
		
		for i in next_cave.center_line:
			y0 = y1
			y1 = i
			if i.x > cave_position:
				break
		if y0:
			enemy_mover.position.y = lerp(y0.y, y1.y, (cave_position-y0.x)/(y1.x-y0.x))
		else:
			enemy_mover.position.y = y1.y
	
