extends AnimatedPart
class_name BossHead

onready var top: Node2D = $ShakeTarget/Sprite
onready var jaw: Sprite = $ShakeTarget/Sprite/Jaw

func _ready():
	$AnimatedSprite.hide()

func _set_data(new_data):
	if new_data is BossHeadResource:
		jaw.texture = new_data.jaw
	
func _end_anim():
	jaw.rotation = 0
	top.rotation = 0

# ANIMATIONS

func _play_idle_anim(duration: float):
	if (duration <= 0):
		duration = 3.8
	
	var jaw_open_time = duration * 0.13
	var open_pause_time = duration * 0.31
	var jaw_close_time = duration * 0.02
	var close_pause_time = duration * 0.52
	var shake_duration = 0.31
	var tween = create_tween()
	tween.tween_property(jaw, "rotation", deg2rad(-20), jaw_open_time)
	tween.tween_interval(open_pause_time)
	tween.tween_property(jaw, "rotation", deg2rad(0), jaw_close_time)
	tween.tween_callback(self, "set_shaking", [true, 1.0, 0.0, shake_duration])
	tween.tween_interval(close_pause_time)
	tween.set_loops()
	tweens.append(tween)

# not used?
func play_biting(top_open_amount := 0.0, jaw_open_amount := 1.0, jaw_open_time := 0.4, open_pause_time := 1.0, bite_time := 0.1, close_pause_time := 2.0, shake_intensity := 0.9, shake_time := 1.2):	
	var tween = create_tween()
	tween.tween_property(jaw, "rotation", deg2rad(-40) * jaw_open_amount, jaw_open_time)
	tween.tween_interval(open_pause_time)
	tween.tween_property(jaw, "rotation", 0, bite_time)
	tween.tween_callback(self, "set_shaking", [true, shake_intensity, shake_intensity, shake_time])
	tween.tween_interval(close_pause_time)
	tweens.append(tween)
	
	var tween2 = create_tween()
	tween2.tween_property(top, "rotation", deg2rad(40) * top_open_amount, jaw_open_time)
	tween2.tween_interval(open_pause_time)
	tween2.tween_property(top, "rotation", 0, bite_time)
	tween2.tween_interval(close_pause_time)
	tweens.append(tween2)

func _play_charge_anim(_duration: float):
	var tween = create_tween()
	tween.tween_callback(self, "play_biting", [0.2, 0.4, 0.08, 0.01, 0.05, 0.01, 0.5, 0.01])
	tween.tween_interval(0.15)
	tween.set_loops()
	tweens.append(tween)

func _play_attack_anim(duration: float):
	$Damageable.invulnerable = false
	var jaw_open_amount := 1.0
	var jaw_open_time = duration * 0.05
	var roar_time = duration * 0.7
	var jaw_close_time = 0.25
	
	var tween = create_tween()
	tween.tween_property(jaw, "rotation", deg2rad(-80) * jaw_open_amount, jaw_open_time)
	tween.tween_callback(self, "set_shaking", [true, 1.0, 1.0, roar_time])
	tween.tween_interval(roar_time)
	tween.tween_property(jaw, "rotation", 0, jaw_close_time)
	tweens.append(tween)
	
	if has_node("Spawner"):
		$Spawner.try_spawn(global_position)
	
	var tween2 = create_tween()
	tween2.tween_property(top, "rotation", deg2rad(40) * jaw_open_amount, jaw_open_time)
	tween2.tween_interval(roar_time)
	tween2.tween_property(top, "rotation", 0, jaw_close_time)
	tweens.append(tween2)

func _play_defend_anim(_duration: float):
	var tween = create_tween()
	tween.tween_callback(self, "play_biting", [0.0, 0.4, 0.5, 0.01, 0.5, 0.01, 0.0, 0.0])
	tween.tween_interval(1.02)
	tween.set_loops()
	tweens.append(tween)
	$Damageable.invulnerable = true
	
