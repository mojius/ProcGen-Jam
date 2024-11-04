extends Node2D
class_name Projectile

var traveling := true
var exploding := false
var direction = Vector2.ZERO
var projectile_resource: ProjectileResource = null
var deadline := 0.0

func _ready():
	$Area2D.connect("area_entered", self, "area_entered")
	$Area2D.connect("body_entered", self, "area_entered")


func explode():
	if exploding:
		# edge case when an explosion has direct hit with two objects
		return
	traveling = false
	exploding = true
	$sprite.hide()	
	if projectile_resource.explosion_size > 1.0:
		$explosion.show()
		$explosion.scale *= projectile_resource.explosion_size
		var explosion_area = $Area2D.duplicate()
		explosion_area.scale *= projectile_resource.explosion_size
		explosion_area.connect("area_entered", self, "indirect_contact_area")
		explosion_area.connect("body_entered", self, "indirect_contact_area")
		call_deferred("add_child", explosion_area)
		var tween = create_tween()
		tween.tween_property($explosion, "modulate", Color(1,1,1,0), projectile_resource.explosion_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		tween.tween_callback(self, "queue_free")
	else:
		queue_free()


func indirect_contact_area(area):
	if area.has_method("damage"):
		area.damage(projectile_resource.indirect_damage)
	elif area is BodyBox:
		area.damage_parts(projectile_resource.indirect_damage)
	


func area_entered(area):
	if area.has_method("damage"):
		area.damage(projectile_resource.direct_damage)
	elif area is BodyBox:
		area.damage_parts(projectile_resource.indirect_damage)
	explode()

func _process(delta):
	if deadline == 0.0:
		deadline = GameManager.elapsed + projectile_resource.life_time
	if deadline < GameManager.elapsed:
		explode()
	if traveling:
		translate(direction*projectile_resource.travel_speed*delta)
		rotation += delta
