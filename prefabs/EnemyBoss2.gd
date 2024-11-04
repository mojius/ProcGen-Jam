extends Node2D

export (Resource) var atlas

var parts_alive = []
var parts_killed = []
var is_destroyed = false

func _ready():
	$AnimatedSprite.hide()
	$AnimatedSprite.connect("animation_finished", self, "emit_signal", ["destroyed"])
	
func post_init():
	parts_alive = $BossVisual.part_list
	for part in parts_alive:
		part.connect("destroyed", self, "destroyed", [part])

	
func build_static_boss():
	$BossVisual.build_boss(
		{
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


func build_random_boss_level(boss_seed):
	
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

signal destroyed
func destroyed(part):
	if part in parts_alive:
		parts_alive.remove(parts_alive.find(part))
		parts_killed.append(part)
		prints("boss has parts left", len(parts_alive), len(parts_killed))
		
	if len(parts_alive) == 0 and not is_destroyed:
		is_destroyed = true
		$AnimatedSprite.show()
		$BossVisual.hide()
		$AnimatedSprite.frame = 0
		$AnimatedSprite.play("default")
		GameManager.destroy_all_projectiles()
		prints("boss destroyed")

		

export var action_cooldown := 0.3
var next_action := 0.0
func _process(_delta):
	var dict = $BossVisual.boss_dict
	
	if len(parts_alive) > 0 and next_action < GameManager.elapsed:
		next_action = GameManager.elapsed + action_cooldown
		var part = parts_alive[randi()%len(parts_alive)]
		part.play_attack_anim(1.0)
	
	if GameManager.player:
		for n in $BossVisual.neck_list:
			n.follow_target.global_position = GameManager.player.get_node("Player").position
