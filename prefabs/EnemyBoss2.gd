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

var total_parts := 0

var saved_seed := 0
func get_rand() -> int:
	var next = rand_seed(saved_seed)
	saved_seed = next[1]
	return next[0]

func get_randf() -> float:
	return float(get_rand() % 1000000) / 1000000.0

func build_random_boss_level(boss_seed: int, level := 1):
	print("building boss: " + String(boss_seed) + " " + String(level))
	# randomize()
	saved_seed = boss_seed
	total_parts = level + int(rand_range(0, 2))
	
	$BossVisual.build_boss(gen_body(boss_seed, level, 1))
	
	for p in $BossVisual.part_list:
		p = p as AnimatedPart
		p.set_health(min(30.0, 5.0 + level))

func gen_body(boss_seed, level, depth):
	var dict = {
		"type": BossVisual.Components.body,
		"resource": atlas.boss_bodies[get_rand() % atlas.boss_bodies.size()],
		"limbs": []
	}
	var limb_count = BossPartAtlas.get_limb_count(dict["resource"])
	
	for _i in range(limb_count):
		if total_parts <= 0:
			break
		
		var limb_roll := randf() # get_randf()
		
		if limb_roll < (0.2 / level) and total_parts > 1:
			dict["limbs"].append({
				"type": BossVisual.Components.none
			})
			print("adding nothing: " + String(total_parts))
			total_parts -= 1
		
		elif limb_roll < 0.7:
			var neck = {
				"type": BossVisual.Components.neck,
				"part": {}
			}
			
			var next_limb_roll := randf() #get_randf()
			
			if next_limb_roll < (0.33 - (0.33 / total_parts)) and depth < 2:
				neck["part"] = gen_body(boss_seed, level, depth + 1)
			
			elif next_limb_roll < 0.66:
				neck["part"] = {
					"type": BossVisual.Components.part,
					"resource": atlas.boss_parts[get_rand() % atlas.boss_parts.size()]
				}
			
			else:
				neck["part"] = {
					"type": BossVisual.Components.head,
					"resource": atlas.boss_heads[get_rand() % atlas.boss_parts.size()]
				}
			
			dict["limbs"].append(neck)
			total_parts -= 1
		
		elif limb_roll < 0.85:
			dict["limbs"].append({
					"type": BossVisual.Components.part,
					"resource": atlas.boss_parts[get_rand() % atlas.boss_parts.size()]
				})
			total_parts -= 1
		
		else:
			dict["limbs"].append({
					"type": BossVisual.Components.head,
					"resource": atlas.boss_heads[get_rand() % atlas.boss_parts.size()]
				})
			total_parts -= 1
		
	return dict
	
	

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
		$AnimatedSprite.playing = false
		$AnimatedSprite.animation = "default"
		var tween = create_tween()
		for i in 10:
			var explosion = $AnimatedSprite.duplicate()
			add_child(explosion)
			explosion.position += Vector2(randi()%100-50, randi()%100-50)
			tween.tween_callback(explosion, "play", ["default"]).set_delay(0.2)
		tween.tween_callback($AnimatedSprite, "play", ["default"]).set_delay(0.2)
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
