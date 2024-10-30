extends BossComponent
class_name AnimatedPart

var data: BossPartResource = null

func set_data(new_data: BossPartResource):
	data = new_data
	play_idle_anim()
	_set_data(new_data)
	
func _set_data(new_data: BossPartResource):
	return

onready var sprite: AnimatedSprite = $ShakeTarget/Sprite
onready var original_scale: float = $ShakeTarget/Sprite.scale.x

enum AnimationState {
	idle,
	charge,
	attack,
	defend
}

static func anim_state_to_str(var state):
	if state == AnimationState.idle:
		return "idle_anim"
	elif state == AnimationState.charge:
		return "charge_anim"
	elif state == AnimationState.attack:
		return "attack_anim"
	elif state == AnimationState.defend:
		return "defend_anim"

var cur_anim_state = AnimationState.idle

func _ready():
	shake_target = $ShakeTarget
	tween_target = $ShakeTarget/Sprite

var anim_timer := 0.0

signal on_anim_over

func _process(delta):
	if anim_timer > 0:
		anim_timer -= delta
		if anim_timer <= 0:
			var last_state = cur_anim_state
			play_idle_anim()
			emit_signal("on_anim_over", self, last_state)

func set_playing(state: bool):
	sprite.playing = state

func play_tween(var tween_name: String, var duration := 0.0):
	if tween_name == "jiggle":
		play_jiggle(duration, original_scale)
	elif tween_name == "stomp":
		play_stomp(duration)
	elif tween_name == "float":
		play_float(duration)
	elif tween_name == "shake":
		set_shaking(true, 2.0, 2.0, duration)

func play_idle_anim(anim_duration := 0.0):
	end_anim()
	sprite.scale = Vector2.ONE * original_scale
	sprite.position = Vector2.ZERO
	cur_anim_state = AnimationState.idle
	sprite.frames = data.idle_anim
	set_playing(true)
	play_tween(data.idle_tween, data.idle_tween_time)
	anim_timer = anim_duration
	_play_idle_anim(anim_duration)

# override for component type specific behavior
func _play_idle_anim(anim_duration):
	return

func play_charge_anim(anim_duration := 0.0):
	end_anim()
	sprite.scale = Vector2.ONE * original_scale
	sprite.position = Vector2.ZERO
	cur_anim_state = AnimationState.charge
	sprite.frames = data.charge_anim
	set_playing(true)
	play_tween(data.charge_tween, data.charge_tween_time)
	anim_timer = anim_duration
	_play_charge_anim(anim_duration)

# override for component type specific behavior
func _play_charge_anim(anim_duration):
	return

func play_attack_anim(anim_duration := 0.0):
	end_anim()
	sprite.scale = Vector2.ONE * original_scale
	sprite.position = Vector2.ZERO
	cur_anim_state = AnimationState.attack
	sprite.frames = data.attack_anim
	set_playing(true)
	play_tween(data.attack_tween, data.attack_tween_time)
	anim_timer = anim_duration
	_play_attack_anim(anim_duration)

# override for component type specific behavior
func _play_attack_anim(anim_duration):
	return

func play_defend_anim(anim_duration := 0.0):
	end_anim()
	sprite.scale = Vector2.ONE * original_scale
	sprite.position = Vector2.ZERO
	cur_anim_state = AnimationState.defend
	sprite.frames = data.defend_anim
	set_playing(true)
	play_tween(data.defend_tween, data.defend_tween_time)
	anim_timer = anim_duration
	_play_defend_anim(anim_duration)

# override for component type specific behavior
func _play_defend_anim(anim_duration):
	return
