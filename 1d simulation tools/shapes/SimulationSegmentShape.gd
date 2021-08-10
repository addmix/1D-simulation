extends SimulationShape
class_name SimulationSegmentShape

export var size : float = 1.0

func _ready() -> void:
	shape = shapes.SEGMENT_SHAPE

func segment_collision(x) -> Dictionary:
	var a = collider
	var b = x.collider
	
	var s : float = size + x.size
	
	var apos : float = a.position + offset
	var bpos : float = b.position + x.offset
	var bposps : float = bpos + s
	
	var delta_pos : float = a.velocity - b.velocity
	var delta_velocity : float = a.velocity - b.velocity
	
	if delta_velocity == 0.0:
		return {}
	
	#time that segment will collide
	var timeplus : float = (-apos + bposps) / (delta_velocity)
	var timeminus : float = -((apos - bposps) / (delta_velocity))
	
	#collider position when segment collides
	var posplus : float = a.position + a.velocity * timeplus
	var posminus : float = a.position + a.velocity * timeminus
	
	var plus : float = abs(posplus - a.position)
	var minus : float = abs(posminus - a.position)
	
	var collision_time : float
	var collision_position : float
	var collision_normal : float = delta_pos / abs(delta_pos)
	
	#can be made branchless
	#get closer point
	if plus < minus:
		#use plus
		collision_position = posplus
		collision_time = timeplus
	else:
		#use minus
		collision_position = posminus
		collision_time = timeminus
	
	
	var mass_ratio : float = a.mass / (a.mass + b.mass)
	
	#teleport out
#	if abs(delta_pos) <= s:
#		if b.get_type() == "SimulationStaticBody":
#			collision_position = bpos + s * collision_normal
#		else:
#			collision_position = lerp(bpos + s * collision_normal, a.position, mass_ratio)
#		return {"a" : a, "b" : b, "position" : collision_position, "time" : 0.0, "normal" : collision_normal}
	
	#collision doesnt happen this frame
	if collision_time <= 0.0:
		return {}
	
	return {"a" : a, "b" : b, "position" : collision_position, "time" : collision_time, "normal" : -collision_normal}

func bound_collision(x) -> Dictionary:
	var a = collider
	var b = x.collider
	
	var apos : float = a.position + offset
	var bpos : float = b.position + x.offset
	var bposps : float = bpos + size
	
	var delta_velocity : float = a.velocity - b.velocity
	if delta_velocity == 0.0:
		return {}
	
	#time that segment will collide
	var timeplus : float = (-apos + bpos + size) / (delta_velocity)
	var timeminus : float = -((apos - bpos + size) / (delta_velocity))
	
	#collider position when segment collides
	var posplus : float = a.position + a.velocity * timeplus
	var posminus : float = a.position + a.velocity * timeminus
	
	var collision_time : float
	var collision_position : float
	var collision_normal : float = float(!x.direction) - float(x.direction)
	
	#can be made branchless
	if x.direction: #right wall
		collision_position = min(posplus, posminus)
	else: #left wall
		collision_position = max(posplus, posminus)
	
	#can be made branchless
	#get correct collision time
	if collision_position == posplus:
		collision_time = timeplus
	else:
		collision_time = timeminus
	
	
	var mass_ratio : float = a.mass / (a.mass + b.mass)
	
	#this teleports objects out of each other
	
	if abs(apos - bpos) < size:
		if b.get_type() == "SimulationStaticBody":
			collision_position = bpos + size * collision_normal
		else:
			collision_position = lerp(bpos + size * collision_normal, apos, mass_ratio)
		return {"a" : a, "b" : b, "position" : collision_position, "time" : collision_time, "normal" : collision_normal}
	
	#collision doesnt happen this frame
	if collision_time <= 0.0:
		return {}
	
	return {"a" : a, "b" : b, "position" : collision_position, "time" : collision_time, "normal" : collision_normal}

func oneway_collision(x) -> Dictionary:
	var delta_pos : float = (collider.position + offset) - (x.collider.position + x.offset)
	
	if x.depth <= 0.0:
		return {}
	
	#right
	if x.direction:
		if delta_pos >= size + x.size:
			return _oneway_collision(x)
		else:
			return {}
	#left side
	else:
		if delta_pos <= -(size + x.size):
			return _oneway_collision(x)
		else:
			return {}

func _oneway_collision(x) -> Dictionary:
	var a = collider
	var b = x.collider
	
	var s : float = size + x.size
	
	var apos : float = a.position + offset
	var bpos : float = b.position + x.offset
	var bposps : float = bpos + s * (float(x.direction) - float(!x.direction))
	
	var delta_pos : float = apos - bpos
	var delta_velocity : float = a.velocity - b.velocity
	
	if delta_pos == 0.0 or delta_velocity == 0.0:
		return {}
	
	#time that segment will collide
	var timeplus : float = (-apos + bposps) / (delta_velocity)
	var timeminus : float = -((apos - bposps) / (delta_velocity))
	
	#collider position when segment collides
	var posplus : float = a.position + a.velocity * timeplus
	var posminus : float = a.position + a.velocity * timeminus
	
	var plus : float = abs(posplus - a.position)
	var minus : float = abs(posminus - a.position)
	
	var collision_time : float
	var collision_position : float
	var collision_normal : float = delta_pos / abs(delta_pos)
	
	#can be made branchless
	#get closer point
	if plus < minus:
		#use plus
		collision_position = posplus
		collision_time = timeplus
	else:
		#use minus
		collision_position = posminus
		collision_time = timeminus
	
	
	var mass_ratio : float = a.mass / (a.mass + b.mass)
	
	#collision doesnt happen this frame
	if collision_time < 0.0:
		return {}
	
	return {"a" : a, "b" : b, "position" : collision_position, "time" : collision_time, "normal" : -collision_normal}
