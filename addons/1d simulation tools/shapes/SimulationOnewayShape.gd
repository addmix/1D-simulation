extends SimulationShape
class_name SimulationOnewayShape

#true = right flase = left
export var size : float = 1.0
export var direction : bool = true

func _ready() -> void:
	shape = shapes.BOUND_SHAPE

func segment_collision(a, b, delta : float) -> Dictionary:
	return {}

func bound_collision(a, b, delta : float) -> Dictionary:
	#time at collisions
	var timeplus : float = (-a.position + b.position + size) / (a.velocity - b.velocity)
	var timeminus : float = -((a.position - b.position + size) / (a.velocity - b.velocity))
	#position at collisions
	var posplus : float = a.position + a.velocity * timeplus
	var posminus : float = a.position + a.velocity * timeminus
	
	var collision_time : float
	var collision_position : float
	var collision_normal : float = float(!b.shape.direction) - float(b.shape.direction)
	
	if b.shape.direction: #right wall
		collision_position = min(posplus, posminus)
	else: #left wall
		collision_position = max(posplus, posminus)
		
	
	#get correct collision time
	if collision_position == posplus:
		collision_time = timeplus
	else:
		collision_time = timeminus
	
	#this teleports objects out of each other
	if b.shape.direction:#right wall
		if a.position + a.shape.size > b.position:
			if b.get_type() == "SimulationStaticBody":
				collision_position = b.position - size
			else:
				collision_position = lerp(b.position - size, a.position, a.mass / (a.mass + b.mass))
			return {"position" : collision_position, "time" : collision_time, "normal" : collision_normal}
	else:#left wall
		if a.position - a.shape.size < b.position:
			if b.get_type() == "SimulationStaticBody":
				collision_position = b.position + size
			else:
				collision_position = lerp(b.position + size, a.position, a.mass / (a.mass + b.mass))
			return {"position" : collision_position, "time" : collision_time, "normal" : collision_normal}
	
	#collision doesnt happen this frame
	if collision_time > delta or collision_time < 0.0:
		return {}
	
	return {"position" : collision_position, "time" : collision_time, "normal" : collision_normal}

func oneway_collision(a, b, delta : float) -> Dictionary:
	return segment_collision(a, b, delta)
