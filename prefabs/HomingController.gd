extends Node2D
class_name HomingController

var homing_target = null

func _process(delta):
	if not homing_target:
		return
	var projectile := get_parent() as Projectile
	if projectile.direction == Vector2.ZERO:
		return
	
	var direction = projectile.direction
	var desired_direction = (homing_target.position - projectile.position)
	projectile.direction = (direction * projectile.projectile_resource.travel_speed + desired_direction*projectile.projectile_resource.rotation_speed).normalized()
