extends Node2D
class_name BossVisual

export var body_diamond_template: PackedScene
export var body_star_template: PackedScene
export var body_vines_template: PackedScene

export var neck_template: PackedScene
export var part_template: PackedScene
export var head_template: PackedScene

var body: BossBody = null

# dict of boss parts organized by parent hierarchy
var boss_dict: Dictionary = {}

var part_list: Array = [] # list of all boss parts (heads, eyes, hands, etc)
var neck_list: Array = [] # list of all necks in the boss
var body_list: Array = [] # list of all bodies in the boss

enum Components {
	body,
	neck,
	part,
	head,
	none
}

# dict is expected in this format:
# {
# 	"type": BossVisual.Components.body,
#	"resource": BossBodyResource,
# 	"limbs" : [
# 		{
# 			"type": BossVisual.Components.neck,
#			"part": {
# 				"type": BossVisual.Components.head,
#				"resource": BossHeadResource
# 			}
# 		},
#		{
#			"type": BossVisual.Components.part,
#			"resource": BossPartResource
#		},
#		...
# 	]
# }
func build_boss(dict):
	body = build_body(dict, self)
	boss_dict = dict
	print(boss_dict)

func build_body(dict, parent) -> BossBody:
	var resource = dict["resource"] as BossBodyResource
	var new_body: BossBody = null
	if resource.body_type == BossBodyResource.BodyType.diamond:
		new_body = body_diamond_template.instance() as BossBody
	elif resource.body_type == BossBodyResource.BodyType.star:
		new_body = body_star_template.instance() as BossBody
	elif resource.body_type == BossBodyResource.BodyType.vines:
		new_body = body_vines_template.instance() as BossBody
	
	
	parent.add_child(new_body)
	new_body.set_data(dict["resource"])
	dict["node"] = new_body
	body_list.append(new_body)
	
	for i in range(dict["limbs"].size()):
		if i >= new_body.limb_points.size():
			break
		
		var next_part = dict["limbs"][i]
		var new_part = null
		
		if next_part["type"] == Components.none:
			continue
			
		if next_part["type"] == Components.body:
			new_part = build_body(next_part, new_body)
			
		elif next_part["type"] == Components.neck:
			new_part = build_neck(next_part, new_body.data.color)
		
		elif next_part["type"] == Components.part:
			new_part = build_part(next_part)
			
		elif next_part["type"] == Components.head:
			new_part = build_head(next_part)
		
		new_body.set_limb(i, new_part)
	
	return new_body

func build_neck(dict, parent_color) -> CircleChain:
	var new_neck = neck_template.instance() as CircleChain
	add_child(new_neck)
	dict["node"] = new_neck
	neck_list.append(new_neck)
	
	var next_part = dict["part"]
	var new_part = null
	
	if next_part == null:
		new_neck.set_gradient(parent_color, parent_color)
		
	if next_part["type"] == Components.body:
		new_part = build_body(next_part, new_neck)
		new_neck.set_gradient(parent_color, new_part.data.color)
		
	elif next_part["type"] == Components.neck:
		new_part = build_neck(next_part, parent_color)
		new_neck.set_gradient(parent_color, parent_color)
		
	elif next_part["type"] == Components.part:
		new_part = build_part(next_part)
		new_neck.set_gradient(parent_color, new_part.data.color)
		
	elif next_part["type"] == Components.head:
		new_part = build_head(next_part)
		new_neck.set_gradient(parent_color, new_part.data.color)
	
	new_neck.set_attached_part(new_part)
	return new_neck

func build_part(dict) -> AnimatedPart:
	var new_part = part_template.instance() as AnimatedPart
	add_child(new_part)
	new_part.set_data(dict["resource"])
	dict["node"] = new_part
	part_list.append(new_part)
	return new_part

func build_head(dict) -> BossHead:
	var new_part = head_template.instance() as BossHead
	add_child(new_part)
	new_part.set_data(dict["resource"])
	dict["node"] = new_part
	part_list.append(new_part)
	return new_part
