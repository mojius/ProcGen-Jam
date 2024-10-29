extends BossComponent
class_name BossHead

var top: Sprite = null
var jaw: Sprite = null
var head: Node2D = null

enum HeadAnimState {
	idle,
	biting,
	roaring
}

var anim_state = HeadAnimState.idle

# Called when the node enters the scene tree for the first time.
func _ready():
	top = $Head/Top
	jaw = $Head/Jaw
	head = $Head
	shake_target = head
	play_idle()

func play_idle(jaw_open_time := 0.5, open_pause_time := 1.2, jaw_close_time := 0.1, close_pause_time := 2.0, shake_intensity := 0.7, shake_duration := 1.2):
	end_anim()
	anim_state = HeadAnimState.idle
	
	var tween = create_tween()
	tween.tween_property(jaw, "rotation", deg2rad(-20), jaw_open_time)
	tween.tween_interval(open_pause_time)
	tween.tween_property(jaw, "rotation", deg2rad(0), jaw_close_time)
	tween.tween_callback(self, "set_shaking", [true, shake_intensity, 0.0, shake_duration])
	tween.tween_interval(close_pause_time)
	tween.set_loops()
	tweens.append(tween)
	
	return jaw_open_time + open_pause_time + jaw_close_time + close_pause_time

func play_biting(jaw_open_amount := 1.0, jaw_open_time := 0.4, open_pause_time := 1.0, bite_time := 0.1, close_pause_time := 2.0, shake_intensity := 0.9, shake_time := 1.2):
	end_anim()
	anim_state = HeadAnimState.biting
	
	var tween = create_tween()
	tween.tween_property(jaw, "rotation", deg2rad(-40) * jaw_open_amount, jaw_open_time)
	tween.tween_interval(open_pause_time)
	tween.tween_property(jaw, "rotation", 0, bite_time)
	tween.tween_callback(self, "set_shaking", [true, shake_intensity, shake_intensity, shake_time])
	tween.tween_interval(close_pause_time)
	tween.tween_callback(self, "play_idle", [])
	tweens.append(tween)
	
	var tween2 = create_tween()
	tween2.tween_property(top, "rotation", deg2rad(40) * jaw_open_amount, jaw_open_time)
	tween2.tween_interval(open_pause_time)
	tween2.tween_property(top, "rotation", 0, bite_time)
	tween2.tween_interval(close_pause_time)
	tweens.append(tween2)
	
	return jaw_open_time + open_pause_time + bite_time + close_pause_time

func play_roar(jaw_open_amount := 1.0, jaw_open_time := 0.15, roar_time := 2.0, shake_intensity := 0.8, jaw_close_time := 0.7):
	end_anim()
	anim_state = HeadAnimState.roaring
	
	var tween = create_tween()
	tween.tween_property(jaw, "rotation", deg2rad(-40) * jaw_open_amount, jaw_open_time)
	tween.tween_callback(self, "set_shaking", [true, shake_intensity, shake_intensity, roar_time])
	tween.tween_interval(roar_time)
	tween.tween_property(jaw, "rotation", 0, jaw_close_time)
	tween.tween_callback(self, "play_idle", [])
	tweens.append(tween)
	
	var tween2 = create_tween()
	tween2.tween_property(top, "rotation", deg2rad(40) * jaw_open_amount, jaw_open_time)
	tween2.tween_interval(roar_time)
	tween2.tween_property(top, "rotation", 0, jaw_close_time)
	tweens.append(tween2)
	
	return jaw_open_time + roar_time + jaw_close_time
