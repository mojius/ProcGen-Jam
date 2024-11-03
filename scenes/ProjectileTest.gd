extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var fired := false

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.spawn_player()


func _process(delta):
	if not fired:
		$Spawner1.try_spawn($Spawner1.position)
		fired = true
