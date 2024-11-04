extends Area2D

export var invulnerable := false
export var max_health := 10.0
export var health := 5.0

func set_health(new_health):
	health = new_health
	max_health = new_health
	$ProgressBar.max_value = max_health
	$ProgressBar.value = health

func _ready():
	health = max_health
	$ProgressBar.max_value = max_health
	$ProgressBar.value = health

func damage(power: float):
	health -= power
	$ProgressBar.value = health
	
	if health <= 0.0:
		get_parent().destroy()
	
