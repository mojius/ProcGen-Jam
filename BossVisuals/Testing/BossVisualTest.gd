extends Node2D

# boss part atlas
export var atlas: Resource

signal on_level_end

# Called when the node enters the scene tree for the first time.
func _ready():
	
	randomize()
	
	var rand_body = atlas.boss_bodies[randi() % atlas.boss_bodies.size()]
	var limb_count = BossPartAtlas.get_limb_count(rand_body)
	
	var dict = {
		"type": BossVisual.Components.body,
		"resource": rand_body,
		"limbs": []
	}
	
	for _i in range(limb_count):
		var rand_part_roll = randf()
		
		if rand_part_roll < 0.25:
			dict["limbs"].append({
				"type": BossVisual.Components.none
			})
		
		elif rand_part_roll < 0.5:
			dict["limbs"].append({
				"type": BossVisual.Components.neck,
				"part": {
					"type": BossVisual.Components.part,
					"resource": atlas.boss_parts[randi() % atlas.boss_parts.size()]
				}
			})
		
		elif rand_part_roll < 0.75:
			dict["limbs"].append({
				"type": BossVisual.Components.head,
				"resource": atlas.boss_heads[randi() % atlas.boss_heads.size()]
			})
		
		else:
			dict["limbs"].append({
				"type": BossVisual.Components.part,
				"resource": atlas.boss_parts[randi() % atlas.boss_parts.size()]
			})
	
	$BossVisual.build_boss(dict)
	
	var tween = create_tween()
	tween.tween_interval(4)
	tween.tween_callback(self, "end_level")

func end_level():
	emit_signal("on_level_end")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var dict = $BossVisual.boss_dict
	
	for n in $BossVisual.neck_list:
		n.follow_target.global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("anim_test1"):
		for n in $BossVisual.part_list:
			n.play_charge_anim(1.0)
		for b in $BossVisual.body_list:
			b.play_charge_anim(1.0)
		
	elif Input.is_action_just_pressed("anim_test2"):
		for n in $BossVisual.part_list:
			n.play_attack_anim(1.0)
			print(n.projectile_point.global_position)
		
	elif Input.is_action_just_pressed("anim_test3"):
		for b in $BossVisual.body_list:
			b.play_defend_anim(6.0)
	
	elif Input.is_action_just_pressed("anim_test4"):
		for b in $BossVisual.body_list:
			b.play_attack_anim(1.0)
