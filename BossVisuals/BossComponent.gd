extends Node2D
class_name BossComponent

var tweens := []
var shake_target: Node2D = null
var tween_target: Node2D = null

func end_anim():
	for t in tweens:
		t.kill()
	tweens.clear()
	is_shaking = false
	_end_anim()

func _end_anim():
	return

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


func play_jiggle(duration := 1.0, original_scale := 2.0, jiggle_intensity := 1.0) -> float:
	var squish_time = duration * 0.63
	var pause_time = duration * 0.36
	var max_scale := original_scale + (0.3 * jiggle_intensity)
	var min_scale := original_scale - (0.3 * jiggle_intensity)
	
	var tween = create_tween()
	tween.tween_property(tween_target, "scale", Vector2(max_scale, min_scale), squish_time).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(pause_time)
	tween.tween_property(tween_target, "scale", Vector2(min_scale, max_scale), squish_time).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(pause_time)
	tween.set_loops()
	tweens.append(tween)
	
	return squish_time + pause_time

func play_stomp(duration := 3.5, lift_amount := 5.0, drop_amount := 5.0, drop_shake_intensity := 2.5) -> float:
	var lift_time = duration * 0.22
	var lift_pause_time = duration * 0.28
	var drop_time = duration * 0.05
	var drop_pause_time = duration * 0.42
	var shake_time = duration * 0.08
	var tween = create_tween()
	tween.tween_property(tween_target, "position", Vector2.UP * lift_amount, lift_time).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(lift_pause_time)
	tween.tween_property(tween_target, "position", Vector2.DOWN * drop_amount, drop_time).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(self, "set_shaking", [true, drop_shake_intensity, 0.0, shake_time])
	tween.tween_interval(drop_pause_time)
	tween.tween_callback(self, "set_shaking", [false])
	tween.set_loops()
	tweens.append(tween)
	
	return lift_time + lift_pause_time + drop_time + drop_pause_time

func play_float(duration := 1, amplitude := 5.0):
	var tween = create_tween()
	tween.tween_property(tween_target, "position", Vector2.UP * amplitude, duration * 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(tween_target, "position", Vector2.DOWN * amplitude, duration * 0.5).set_trans(Tween.TRANS_SINE)
	tween.set_loops()
	tweens.append(tween)
