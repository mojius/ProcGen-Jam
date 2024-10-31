extends Node2D

export var slime: Resource = null
export var eye: Resource = null
export var hawk: Resource = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$BossVisual.build_boss({
		"type": BossVisual.Components.body,
		"resource": slime,
		"limbs": [
			{
				"type": BossVisual.Components.neck,
				"part":{
					"type": BossVisual.Components.body,
					"resource": slime,
					"limbs": [
						{
							"type": BossVisual.Components.head,
							"resource": hawk
						},
					]
				}
			},
			{
				"type": BossVisual.Components.neck,
				"part": {
					"type": BossVisual.Components.neck,
					"part": {
						"type": BossVisual.Components.part,
						"resource": eye
					}
				}
			},
			{
				"type": BossVisual.Components.neck,
				"part": {
					"type": BossVisual.Components.part,
					"resource": eye
				}
			}
		]
	})


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var dict = $BossVisual.boss_dict
	
	for n in $BossVisual.neck_list:
		n.follow_target.global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("anim_test1"):
		for n in $BossVisual.part_list:
			n.play_charge_anim(1.0)
		
	elif Input.is_action_just_pressed("anim_test2"):
		for n in $BossVisual.part_list:
			n.play_attack_anim(1.0)
		
	elif Input.is_action_just_pressed("anim_test3"):
		for b in $BossVisual.body_list:
			b.play_defend_anim(6.0)
		
