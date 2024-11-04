extends Resource
class_name ProjectileResource

export(float) var cooldown := 0.6
export(int) var num_projectiles := 1
export(float) var spread_angle := 1.0
export(float) var spread_delay := 0.0
export(float) var size := 1.0
export(float) var life_time := 30.0
export(float) var travel_speed := 300.0
export(float) var rotation_speed := 300.0
export(float) var direct_damage := 1.0
export(float) var indirect_damage := 0.5
export(float) var explosion_size := 3.0
export(float) var explosion_time := 0.3
export(float) var lingering_damage := 0.5
export var homing := false
"""
projectile trajectory:
  straight
  wave/sine
  random
  hover
  spread
effects:
  freeze/slow down
  burn/poison/damage over time
  spawn secondary projectiles
"""

var added_projectiles := 0
var cooldown_reduction := 0.0
var speed_up := 0.0
var added_damage := 0.0
var added_explosion_size := 0.0
var added_spread_angle := 1.0
var added_size := 0.0
