extends Node2D
class_name BossComponent

var tweens := []
var shake_target: Node2D = null

func end_anim():
	for t in tweens:
		t.kill()
	tweens.clear()
	is_shaking = false

var is_shaking := false
var shake_timer := 0.0
var shake_x_intensity := 1.0
var shake_y_intensity := 1.0

func set_shaking(state := true, x_intensity := 1.0, y_intensity := 1.0, duration := 99.0):
	is_shaking = state
	shake_x_intensity = x_intensity
	shake_y_intensity = y_intensity
	shake_timer = duration

func _process(delta):
	if shake_target:
		if is_shaking:
			shake_target.position = Vector2(rand_range(-shake_x_intensity, shake_x_intensity), rand_range(-shake_y_intensity, shake_y_intensity))
		else:
			shake_target.position = Vector2.ZERO
		
		if shake_timer > 0:
			shake_timer -= delta
		if shake_timer <= 0:
			is_shaking = false
