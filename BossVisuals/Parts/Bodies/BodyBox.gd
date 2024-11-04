extends StaticBody2D
class_name BodyBox

func damage_parts(damage):
	var body = get_parent().get_parent() as BossBody
	for i in range(body.limb_points.size()):
		var limb = body.get_limb(i)
		if limb:
			if limb is AnimatedPart:
				limb.damage(damage / 3.0)
			elif limb is CircleChain:
				if limb.attached_part is AnimatedPart:
					limb.attached_part.damage(damage / 3.0)
	
