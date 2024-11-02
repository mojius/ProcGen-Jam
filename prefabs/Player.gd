extends Node2D
class_name Player
signal hit

var playable := true
var SPEED := 200.0
onready var body = $Player
onready var spawner = $Player/Spawner
var powerups = []
var powerup_mode = 1
export var powerup_radius = 75
export var powerup_rotation_speed = 2.0

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
	move_powerups(delta)
			
func move_powerups(delta):
	if not powerups: 
		return
	var powerup_delta = 2.0 / len(powerups)
	for i in len(powerups):		
		var powerup_elapsed = GameManager.elapsed * powerup_rotation_speed + powerup_delta * i * PI
		powerups[i].position = $Player.position + Vector2(cos(powerup_elapsed), sin(powerup_elapsed)) * powerup_radius # + Vector2(-100, 50)
		
	
