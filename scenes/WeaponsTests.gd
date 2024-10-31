extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var enemy = preload("res://prefabs/EnemyTarget.tscn")
	for x in 3:
		for y in 10:
			var e = enemy.instance()
			e.position = Vector2(x * 50 + 200, (y - 5) * 50)
			add_child(e)
	enemy = preload("res://prefabs/EnemyBasic.tscn")
	var e = enemy.instance()
	e.position = Vector2(400, 0)
	add_child(e)

	GameManager.spawn_player()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
