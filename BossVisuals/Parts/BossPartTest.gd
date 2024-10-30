extends Node2D

export var boss_part: Resource = null
export var boss_head: Resource = null

func _ready():
	$AnimatedPart.set_data(boss_part)
	$AnimatedPart.connect("on_anim_over", self, "on_anim_over")
	$BossHead.set_data(boss_head)
	$BossHead.connect("on_anim_over", self, "on_anim_over")
	

func on_anim_over(part: BossComponent, state):
	print(AnimatedPart.anim_state_to_str(state) + " ended on " + part.name)

func _process(delta):
	if Input.is_action_just_pressed("anim_test1"):
		$AnimatedPart.play_charge_anim(1.0)
		$BossHead.play_charge_anim(1.0)
	elif Input.is_action_just_pressed("anim_test2"):
		$AnimatedPart.play_attack_anim(1.0)
		$BossHead.play_attack_anim(1.0)
	elif Input.is_action_just_pressed("anim_test3"):
		$AnimatedPart.play_defend_anim(6.0)
		$BossHead.play_defend_anim(6.0)
