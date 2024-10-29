extends Node2D
class_name Projectile

var direction = Vector2.ZERO
export (Resource) var projectile_resource = ProjectileResource.new()

func _ready():
	$Area2D.connect("area_entered", self, "area_entered")
	$Area2D.connect("body_entered", self, "body_entered")


func area_entered(area):
	queue_free()

func body_entered(area):
	queue_free()

func _process(delta):
	translate(direction*projectile_resource.travel_speed*delta)
	rotation += delta
