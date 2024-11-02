extends Node2D

export (Resource) var atlas
func _ready():
	$BossVisual.build_boss({
		"type": BossVisual.Components.body,
		"resource": atlas.boss_bodies[0],
		"limbs": [
						{
							"type": BossVisual.Components.head,
							"resource": atlas.boss_heads[0]
						},

			{
				"type": BossVisual.Components.neck,
				"part": {
					"type": BossVisual.Components.neck,
					"part": {
						"type": BossVisual.Components.part,
						"resource": atlas.boss_parts[0]
					}
				}
			},
						{
				"type": BossVisual.Components.neck,
				"part":{
					"type": BossVisual.Components.body,
					"resource": atlas.boss_bodies[0],
					"limbs": [
						{
							"type": BossVisual.Components.head,
							"resource": atlas.boss_heads[0]
						},
					]
				}
			},

			
			{
				"type": BossVisual.Components.neck,
				"part": {
					"type": BossVisual.Components.part,
					"resource": atlas.boss_parts[0]
				}
			}
		]
	})


export var action_cooldown := 0.3
var next_action := 0.0
func _process(_delta):
	var dict = $BossVisual.boss_dict
	
	if next_action < GameManager.elapsed:
		next_action = GameManager.elapsed + action_cooldown
		var part = $BossVisual.part_list[randi()%len($BossVisual.part_list)]
		part.play_attack_anim(1.0)
	
	if GameManager.player:
		for n in $BossVisual.neck_list:
			n.follow_target.global_position = GameManager.player.get_node("Player").position
	
	if Input.is_action_just_pressed("anim_test1"):
		for n in $BossVisual.part_list:
			n.play_charge_anim(1.0)
		
	elif Input.is_action_just_pressed("anim_test2"):
		for n in $BossVisual.part_list:
			n.play_attack_anim(1.0)
		
	elif Input.is_action_just_pressed("anim_test3"):
		for b in $BossVisual.body_list:
			b.play_defend_anim(6.0)
		
