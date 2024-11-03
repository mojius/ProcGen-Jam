extends Node

onready var screen_size := get_tree().root.size

onready var level_layer = get_tree().current_scene
onready var player_layer = get_tree().current_scene
onready var player_projectile_layer = get_tree().current_scene
onready var enemy_projectile_layer = get_tree().current_scene
onready var enemy_layer = get_tree().current_scene
onready var explosion_layer = get_tree().current_scene

var player: Player = null

var elapsed := 0.0

func _ready():
	pass
	
func _process(delta):
	elapsed += delta
	
var player_prefab := preload("res://prefabs/Player.tscn") as PackedScene

func spawn_player():
	if player == null:
		player = player_prefab.instance()
		player_layer.add_child(player)
		player.connect("hit", self, "spawn_player")
	player.spawn()
	return player
	


func explosion(explosion_scene: PackedScene, position_: Vector2):
	var explosion = explosion_scene.instance()
	explosion.position = position_
	explosion_layer.add_child(explosion)
	explosion.explode()


func destroy_all_projectiles():
	for i in GameManager.player_projectile_layer.get_children():
		i.queue_free()
	for i in GameManager.enemy_projectile_layer.get_children():
		i.queue_free()
