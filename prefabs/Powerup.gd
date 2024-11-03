extends Node2D

var kind = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("area_entered", self, "pickup")
	$Area2D.connect("body_entered", self, "pickup")
	
func pickup(area):
	prints("powerup pickup", area, kind)
	var current_list = get_parent().powerups
	current_list.remove(current_list.find(self))
	var player = area.get_parent() as Player
	player.powerups.append(self)
	var spawner = player.get_node("Player/Spawner") as Spawner
	#sprints(kind, spawner, spawner.num_projectiles)
	
	match kind:
		0:
			spawner.num_projectiles += 2
		1:
			spawner.cooldown *= 0.5
		2:
			spawner.projectile_resource.travel_speed += 100
		3:
			spawner.projectile_resource.direct_damage *= 2
		4:
			spawner.projectile_resource.explosion_size *= 1
		5:
			spawner.spread_angle *= 0.5
			#spawner.spread_delay *= 2
		6:
			spawner.projectile_resource.size *= 2
			
	
	prints(spawner, spawner.num_projectiles)
	
	

var colors = [
	Color.azure,
	Color.darkred,
	Color.orangered,
	Color.royalblue,
	Color.gold,
	Color.darkslateblue,
	Color.limegreen
]

func set_powerup(idx):
	kind = idx
	#$Circle1.hide()
	#$Circle2.hide()
	#$Circle2.hide()
	#var node = get_node("Circle" + str(idx+1))
	#node.show()
	$AnimatedSprite.play("p" + str(idx+1))
	$Particles2DTrail.process_material = $Particles2DTrail.process_material.duplicate()
	$Particles2DRing.process_material = $Particles2DRing.process_material.duplicate()
	$Particles2DTrail.process_material.color = colors[idx]
	$Particles2DRing.process_material.color = colors[idx]

