extends SimulationShape
class_name SimulationOnewayShape

#true = right flase = left
export var size : float = 1.0
export var depth : float = 1.0
export var stiffness : float = 1.0
export var friction : float = 0.0
export var direction : bool = true

func _ready() -> void:
	shape = shapes.ONEWAY_SHAPE

func segment_collision(x) -> Dictionary:
	var delta_pos : float = (x.collider.position + x.offset) - (collider.position + offset)
	
	if depth <= 0.0:
		return {}
	
	#right
	if direction:
		if delta_pos >= size + x.size:
			return _segment_collision(x)
		else:
			return {}
	#left side
	else:
		if delta_pos <= -(size + x.size):
			return _segment_collision(x)
		else:
			return {}

func _segment_collision(x) -> Dictionary:
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
	var a = collider
	var b = x.collider
	
	var s : float = size + x.size
	var apos : float = a.position + offset
	var bpos : float = b.position + x.offset
	var bposps : float = bpos + size
	
	var delta_pos : float = bpos - apos
	var delta_velocity : float = b.velocity - a.velocity
	
	if delta_pos == 0.0:
		return {}
	if delta_velocity == 0.0:
		return {}
	
	var delta_pos_normal : float = delta_pos / abs(delta_pos)
	var delta_velocity_normal : float = delta_velocity / abs(delta_velocity)
	
	var normal : float = float(!direction) - float(direction)
	
	#if they face the same way, they will never collide
	if direction == x.direction:
		return {}
	
	#if the colliding sides are together
	var direction_check : bool = delta_pos_normal == normal
	var velocity_check : bool = delta_velocity_normal == delta_pos_normal
	var distance_check : bool = abs(delta_pos) >= s
	
	if direction_check and velocity_check and distance_check:
		return segment_collision(x)
	
	return {}
