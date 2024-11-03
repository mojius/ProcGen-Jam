extends Resource
class_name BossPartResource

export var color: Color = Color.white

export var idle_anim: SpriteFrames = null
export(String, "", "shake", "stomp", "float", "jiggle") var idle_tween
export var idle_tween_time: float = 1.0

export var charge_anim: SpriteFrames = null
export(String, "", "shake", "stomp", "float", "jiggle") var charge_tween
export var charge_tween_time: float = 1.0

export var attack_anim: SpriteFrames = null
export(String, "", "shake", "stomp", "float", "jiggle") var attack_tween
export var attack_tween_time: float = 1.0

export var defend_anim: SpriteFrames = null
export(String, "", "shake", "stomp", "float", "jiggle") var defend_tween
export var defend_tween_time: float = 1.0

export(Resource) var projectile: Resource = null
