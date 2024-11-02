extends Resource
class_name BossPartAtlas

export(Array) var boss_bodies = []
export(Array) var boss_parts = []
export(Array) var boss_heads = []


static func get_limb_count(body_resource: BossBodyResource) -> int:
	if body_resource.body_type == BossBodyResource.BodyType.diamond:
		return 4
	elif body_resource.body_type == BossBodyResource.BodyType.star:
		return 5
	elif body_resource.body_type == BossBodyResource.BodyType.vines:
		return 3
	return 1
