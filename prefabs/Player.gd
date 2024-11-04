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
export var destroy_time = 1.0

func _physics_process(delta):
	if not playable:
		return
	var direction: Vector2
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	body.move_and_slide(direction * SPEED)


func spawn():
	playable = true
	#$Player.invulnerable = true		
	#$Player/Camera2D.current = true
	#var tween = create_tween()
	#$Player.position -= Vector2(100,0)
	#tween.tween_property($Player, "position", $Player.position + Vector2(100,0), destroy_time)
	#tween.tween_callback(self, "set_playable").set_delay()
	

func set_playable():
	playable = true
	#$Player.invulnerable = fals
	$Player.invulnerable = true
	$Player.reset_health()
	$Player/WitchVisual/shield.modulate = Color.white
	var tween = create_tween()
	tween.tween_property($Player/WitchVisual/shield, "modulate", Color(1,1,1,0), 1.0)
	tween.tween_callback(self, "set_vulnerable")
	
	
func set_vulnerable():
	$Player.invulnerable = false


func destroy():
	if playable:
		$Player.invulnerable = true
		playable = false
		$Player/WitchVisual.die()
		var tween = create_tween()
		tween.set_parallel(true)
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property($Player/WitchVisual, "position", $Player/WitchVisual.position + Vector2(0,400), destroy_time)
		tween.tween_property($Player/WitchVisual, "rotation", 4, destroy_time)
		tween.tween_callback(self, "destroy_reset").set_delay(destroy_time)
	
func destroy_reset():
	$Player/WitchVisual.spawn()
	$Player/WitchVisual.rotation = 0
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Player/WitchVisual, "position", $Player/WitchVisual.position + Vector2(0,-400), destroy_time)
	tween.tween_callback(self, "set_playable")
	$Player/WitchVisual/shield.show()
	$Player/WitchVisual/shield.modulate = Color.white
	
	

func _process(delta):
	if not playable:
		return
	var velocity := Vector2.ZERO
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
		
	
