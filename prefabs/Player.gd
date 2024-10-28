extends Node2D
class_name Player
signal hit

var playable := true
var SPEED := 200.0
onready var body = $Player
onready var spawner = $Player/Spawner

func _physics_process(delta):
	var direction: Vector2
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	body.move_and_slide(direction * SPEED)
	
func spawn():
	$Player/Camera2D.current = true
	
func _process(delta):
	var velocity := Vector2.ZERO
	if playable:
		if Input.is_action_pressed("fire"):
			spawner.try_spawn(body.position)
