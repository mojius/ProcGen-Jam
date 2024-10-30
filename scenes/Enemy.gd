extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func destroy():
	call_deferred("queue_free")
	
func _process(delta):
	if has_node("Spawner"):
		$Spawner.try_spawn(position)
