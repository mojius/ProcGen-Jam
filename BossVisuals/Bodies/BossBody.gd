extends BossComponent
class_name BossBody

enum BodyAnimState {
	jiggle,
	stomp
}

# current anim state
var anim_state = BodyAnimState.jiggle

# actual limb parents
var limb_points: Array = []
# references to keep limbs aligned with body
var limb_ref_points: Array = []

onready var body: Sprite = $Body/BodySprite
onready var original_scale: float = $Body/BodySprite.scale.x

# Called when the node enters the scene tree for the first time.
func _ready():
	shake_target = $Body
	
	for n in body.get_children():
		limb_ref_points.append(n)
		var limb_point = Node2D.new()
		add_child(limb_point)
		limb_points.append(limb_point)
		limb_point.global_position = n.global_position
	
	if anim_state == BodyAnimState.jiggle:
		play_jiggle()
	else:
		pass

# LIMB BUILDING

func set_limb(var i: int, var limb: BossComponent):
	limb.get_parent().remove_child(limb)
	limb_points[i].add_child(limb)
	limb.position = Vector2.ZERO
	if ("source_dir" in limb and limb_ref_points[i] is LimbPoint):
		limb.source_dir = limb_ref_points[i].source_dir

func get_limb(var i: int):
	return limb_points[i].get_child(0)

func _process(_delta):
	for i in range(limb_points.size()):
		limb_points[i].global_position = limb_ref_points[i].global_position

# SIGNALS: all provide this BossBody as an argument

signal on_stomp

func _invoke_on_stomp():
	emit_signal("on_stomp", self)

# ANIMATIONS: returns total anim duration

func play_jiggle(squish_time := 0.7, pause_time := 0.4, jiggle_intensity := 1.0) -> float:
	end_anim()
	anim_state = BodyAnimState.jiggle
	
	var max_scale := original_scale + (0.3 * jiggle_intensity)
	var min_scale := original_scale - (0.3 * jiggle_intensity)
	
	var tween = create_tween()
	tween.tween_property(body, "scale", Vector2(max_scale, min_scale), squish_time).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(pause_time)
	tween.tween_property(body, "scale", Vector2(min_scale, max_scale), squish_time).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(pause_time)
	tween.set_loops()
	tweens.append(tween)
	
	return squish_time + pause_time

func play_stomp(lift_time := 0.8, lift_amount := 10.0, lift_pause_time := 1.0, drop_time := 0.2, drop_amount := 5.0, drop_pause_time := 1.5, drop_shake_intensity := 2.5, shake_time := 0.3) -> float:
	end_anim()
	anim_state = BodyAnimState.stomp
	
	var tween = create_tween()
	tween.tween_property(body, "position", Vector2.UP * lift_amount, lift_time).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(lift_pause_time)
	tween.tween_property(body, "position", Vector2.DOWN * drop_amount, drop_time).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(self, "_invoke_on_stomp")
	tween.tween_callback(self, "set_shaking", [true, drop_shake_intensity, 0.0, shake_time])
	tween.tween_interval(drop_pause_time)
	tween.tween_callback(self, "set_shaking", [false])
	tween.set_loops()
	tweens.append(tween)
	
	return lift_time + lift_pause_time + drop_time + drop_pause_time
