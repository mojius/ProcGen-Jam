extends Node2D


export var scroll_speed := 50.0
var cave_length = 2048
var cave_prefab = preload("res://prefabs/Cave.tscn")
var last_cave = null
var next_cave = null
var prev_cave = []
var player = null
var enemy_mover = null
var powerups = []

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
	
	#GameManager.spawn_player()
	
func spawn_new_boss(boss_seed):
	if enemy_mover:
		enemy_mover.queue_free()
	var enemy = preload("res://prefabs/EnemyBoss2.tscn").instance()
	#enemy.build_static_boss()
	enemy.build_random_boss_level(21)
	enemy.post_init()
	enemy.position.x = 550
	add_child(enemy)
	enemy.connect("destroyed", self, "end_level")
	enemy_mover = enemy
	
signal on_level_end
func end_level():
	GameManager.player.playable = false
	yield(get_tree().create_timer(2), "timeout")
	GameManager.player.queue_free()
	GameManager.player = null
	player = null
	emit_signal("on_level_end")

func spawn_some_powerups():
	var powerup_ = preload("res://prefabs/Powerup.tscn")
	var num_powerups = 7
	for i in num_powerups:
		var powerup = powerup_.instance()
		powerup.position.x = 128 + 512.0/num_powerups * i
		powerup.position.y = get_cave_center_y(1024-powerup.position.x)
		powerup.set_powerup(i)
		add_child(powerup)
		powerups.append(powerup)


func _process(delta):
	if not player:
		return
	$ParallaxBackground.scroll_base_offset += delta*Vector2.LEFT * 100
	last_cave.position.x -= scroll_speed * delta
	next_cave.position.x -= scroll_speed * delta
	for i in powerups:
		i.position.x -= scroll_speed * delta
	if next_cave.position.x < cave_length * -0.5:
		last_cave.queue_free()
		last_cave = next_cave
		next_cave = cave_prefab.instance()
		next_cave.position.x = last_cave.position.x + cave_length
		GameManager.level_layer.add_child(next_cave)
		prev_cave = next_cave.make_cave(prev_cave)
	$PlayAreaMargins.position.y = player.get_node("Player").position.y
	$ParallaxBackground/TextureRect.rect_position.y = player.get_node("Player").position.y - 300
	$ParallaxBackground/ParallaxLayer1/TextureRect.rect_position.y = player.get_node("Player").position.y - 300
	$ParallaxBackground/ParallaxLayer2/TextureRect.rect_position.y = player.get_node("Player").position.y - 300
	$ParallaxBackground/ParallaxLayer3/TextureRect.rect_position.y = player.get_node("Player").position.y - 300
	$ParallaxBackground/ParallaxLayer4/TextureRect.rect_position.y = player.get_node("Player").position.y - 300
	
	if enemy_mover:
		enemy_mover.position.y = get_cave_center_y(1024*0.125)
		
		
			
func get_cave_center_y(offset):
		var cave_position = 1024*0.5 - next_cave.position.x - offset
		var y0 = null
		var y1 = null
		
		for i in next_cave.center_line:
			y0 = y1
			y1 = i
			if i.x > cave_position:
				break
		if y0:
			return lerp(y0.y, y1.y, (cave_position-y0.x)/(y1.x-y0.x))
		else:
			return y1.y
	
	
