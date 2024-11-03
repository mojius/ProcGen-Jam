extends KinematicBody2D


export var invulnerable := false
export var max_health := 10.0
export var health := 5.0

func _ready():
	reset_health()
	
	
func reset_health():
	health = max_health
	$ProgressBar.max_value = max_health
	$ProgressBar.value = health

func damage(power: float):
	if not invulnerable:
		health -= power
		$ProgressBar.value = health
		
		if health < 0.0:
			get_parent().destroy()
	
