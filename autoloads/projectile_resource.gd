extends Resource
class_name ProjectileResource

export(float) var size := 1.0
export(float) var life_time := 30.0
export(float) var travel_speed := 300.0
export(float) var rotation_speed := 300.0
export(float) var direct_damage := 1.0
export(float) var indirect_damage := 0.5
export(float) var explosion_size := 3.0
export(float) var explosion_time := 0.3
export(float) var lingering_damage := 0.5
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
