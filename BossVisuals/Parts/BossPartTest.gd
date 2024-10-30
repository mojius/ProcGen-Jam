extends Node2D

export var boss_part: Resource = null

func _ready():
	$AnimatedPart.data = boss_part
	$AnimatedPart.play_idle_anim()
	$AnimatedPart.connect("on_anim_over", self, "on_anim_over")

func on_anim_over(state):
	print(AnimatedPart.anim_state_to_str(state) + " ended")

func _process(delta):
	if Input.is_action_just_pressed("anim_test1"):
		$AnimatedPart.play_charge_anim(1.0)
	elif Input.is_action_just_pressed("anim_test2"):
		$AnimatedPart.play_attack_anim(1.0)
	elif Input.is_action_just_pressed("anim_test3"):
		$AnimatedPart.play_defend_anim(6.0)
