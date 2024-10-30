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
	enemy_mover = Node2D.new()
	#enemy_mover.position = player.get_node("Player").position
	add_child(enemy_mover)
	var enemy = preload("res://prefabs/EnemyBasic.tscn")
	for x in 3:
		for y in 10:
			var e = enemy.instance()
			e.position = Vector2(x * 50 + 300, (y - 5) * 50)
			enemy_mover.add_child(e)

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
		var cave_position = 1024*0.5 + next_cave.position.x * -1.0
		var y = 0.0
		for i in next_cave.center_line:
			y = i.y
			if i.x > cave_position:
				break
		enemy_mover.position.y = y
	
