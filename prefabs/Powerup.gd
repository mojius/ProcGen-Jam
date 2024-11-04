extends Node2D
class_name PowerUp

var kind = -1
var power := 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("area_entered", self, "pickup")
	$Area2D.connect("body_entered", self, "pickup")
	
func pickup(area):
	prints("powerup pickup", area, kind)
	var current_list = get_parent().powerups
	if self in current_list:
		current_list.remove(current_list.find(self))
	var player = area.get_parent() as Player
	player.powerups.append(self)
	var spawner = player.get_node("Player/Spawner") as Spawner
	
	match kind:
		0:
			spawner.projectile_resource.num_projectiles += 2 * int(power)
		1:
			spawner.cooldown *= 0.5 * power
		2:
			spawner.projectile_resource.travel_speed += 100 * power
		3:
			spawner.projectile_resource.direct_damage *= 2 * power
		4:
			spawner.projectile_resource.explosion_size *= 1 * power
		5:
			spawner.projectile_resource.spread_angle *= 0.5 * power
			#spawner.spread_delay *= 2
		6:
			spawner.projectile_resource.projectile_resource.size *= 2 * power
	
	

var colors = [
	Color.azure,
	Color.darkred,
	Color.orangered,
	Color.royalblue,
	Color.gold,
	Color.darkslateblue,
	Color.limegreen
]

func set_powerup(idx, pwr := 1.0):
	kind = idx
	power = pwr
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

