extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var idx = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("area_entered", self, "pickup")
	$Area2D.connect("body_entered", self, "pickup")
	
func pickup(area):
	prints("powerup pickup", area)
	var current_list = get_parent().powerups
	current_list.remove(current_list.find(self))
	area.get_parent().powerups.append(self)
	

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

