extends SimulationShape
class_name SimulationSegmentShape

export var size : float = 1.0

func _ready() -> void:
	shape = shapes.SEGMENT_SHAPE

func segment_collision(a, b, delta : float) -> Dictionary:
	var s : float = size + b.shape.size
	#time at collisions
	var timeplus : float = (-a.position + b.position + s) / (a.velocity - b.velocity)
	var timeminus : float = -((a.position - b.position + s) / (a.velocity - b.velocity))
	#position at collisions
	var posplus : float = a.position + a.velocity * timeplus
	var posminus : float = a.position + a.velocity * timeminus
	
	var plus : float = abs(posplus - a.position)
	var minus : float = abs(posminus - a.position)
	
	var collision_time : float
	var collision_position : float
	var collision_normal : float
	
	#get closer point
	if plus < minus:
		#use plus
		collision_position = posplus
		collision_time = timeplus
		collision_normal = float(posplus > posminus) + -float(posplus <= posminus)
	else:
		#use minus
		collision_position = posminus
		collision_time = timeminus
		collision_normal = float(posminus > posplus) + -float(posminus <= posplus)
	
	#collision doesnt happen this frame
	if collision_time > delta or collision_time < 0.0:
		return {}
	
	return {"position" : collision_position, "time" : collision_time, "normal" : collision_normal}
