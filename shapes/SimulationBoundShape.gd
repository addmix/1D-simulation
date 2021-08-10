extends SimulationShape
class_name SimulationBoundsShape

#true = right flase = left
export var direction : bool = true

func _ready() -> void:
	shape = shapes.BOUND_SHAPE

func segment_collision(x) -> Dictionary:
	var a = collider
	var b = x.collider
	
	var apos : float = a.position + offset
	var bpos : float = b.position + x.offset
	
	var delta_velocity : float = a.velocity - b.velocity
	
	if delta_velocity == 0.0:
		return {}
	
	#time at collisions
	var timeplus : float = (-apos + bpos + x.size) / (delta_velocity)
	var timeminus : float = -((apos - bpos + x.size) / (delta_velocity))
	#position at collisions
	var posplus : float = a.position + a.velocity * timeplus
	var posminus : float = a.position + a.velocity * timeminus
	
	var collision_time : float
	var collision_position : float
	var collision_normal : float = float(!direction) - float(direction)
	
	if direction: #right wall
		collision_position = min(posplus, posminus)
	else: #left wall
		collision_position = max(posplus, posminus)
		
	
	#get correct collision time
	if collision_position == posplus:
		collision_time = timeplus
	else:
		collision_time = timeminus
	
	var mass_ratio : float = a.mass / (a.mass + b.mass)
	
	#inside, teleport out
	if abs(apos - bpos) < x.size:
		if b.get_type() == "SimulationStaticBody":
			collision_position = bpos - x.size * collision_normal
		else:
			collision_position = lerp(bpos - x.size * collision_normal, a.position, mass_ratio)
		return {"a" : a, "b" : b, "position" : collision_position, "time" : collision_time, "normal" : collision_normal}
	
	#collision doesnt happen this frame
	if collision_time <= 0.0:
		return {}
	
	return {"a" : a, "b" : b, "position" : collision_position, "time" : collision_time, "normal" : collision_normal}

func bound_collision(x) -> Dictionary:
	return {}

func oneway_collision(x) -> Dictionary:
	return segment_collision(x)
