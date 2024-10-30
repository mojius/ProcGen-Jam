extends BossComponent
class_name CircleChain

# use to connect a boss body part to another part, or the main body.
# set this node's position to where it will be parented to.

# the max dist between chain links
export var max_dist := 25.0
var circles := []

# set follow target's global position to control where chain bends to
var follow_target: Node2D = null
# the chain will bend towards the follow target, starting from this direction
var source_dir := Vector2.LEFT

var attach_point: Node2D = null
var attached_part: BossComponent = null

# Called when the node enters the scene tree for the first time.
func _ready():
	circles.append($Sprite)
	circles.append($Sprite2)
	circles.append($Sprite3)
	circles.append($Sprite4)
	circles.append($Sprite5)
	circles.append($Sprite6)
	circles.append($Sprite7)
	follow_target = $FollowTarget
	attach_point = $AttachPoint

# use to set the boss body part this chain connects to
func set_attached_part(part):
	attached_part = part
	attached_part.get_parent().remove_child(attached_part)
	attach_point.add_child(attached_part)
	attached_part.position = Vector2.ZERO
	
func set_gradient(color1: Color, color2: Color):
	for i in range(circles.size()):
		var circle = circles[i] as Sprite
		circle.modulate = color1.linear_interpolate(color2, float(i) / (circles.size() - 1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if follow_target:
		var diff = follow_target.position
		var dir = diff.normalized()
		var dist = diff.length()
		
		var start_angle = source_dir.angle()
		var end_angle = dir.angle()
		
		var circle_dist = (dist * (1 + ((start_angle - abs(end_angle)) * 0.05))) / circles.size()
		
		for i in range(circles.size()):
			if i == 0:
				continue
			var circle = circles[i] as Sprite
			var progress = float(i) / (circles.size() - 1)
			var next_dir = Vector2.RIGHT.rotated(lerp_angle(start_angle, end_angle, progress))
			var next_dist = min(max_dist, diff.length() / i)
			circle.position = circles[i - 1].position + (next_dir * min(max_dist, circle_dist))
			start_angle = next_dir.angle()
			end_angle = (follow_target.position - circle.position).angle()
		
		attach_point.position = circles[circles.size() - 1].position
