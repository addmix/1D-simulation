extends SimulationObject
class_name SimulationCollider

signal on_collided

#objects we will check collision on, in nodepaths
var to_collide : Array = []

export var friction : float = 0.0 #could be called damping
export var bounce : float = 0.0
export var mass : float = 1.0

export var shape : Resource


func _step(delta : float) -> void:
	if !is_inside_tree():
		return
	#position
	set_end_position(position + velocity * delta)
	#velocity
	set_end_velocity(velocity)
	for collider_path in to_collide:
		
		
		var collider_node = get_node(collider_path)
		#check for collision
		test_move(self, collider_node, delta)
	
	#apply friction here
	#friction force
	var force : float = end_velocity / abs(end_velocity) * friction * delta
	var new_velocity : float = end_velocity - force
	var changed_direction : bool = (new_velocity > 0.0 and end_velocity <= 0.0) or (new_velocity <= 0.0 and end_velocity > 0.0)
	end_velocity = float(!changed_direction) * new_velocity

func test_move(a : SimulationCollider, b : SimulationCollider, delta : float) -> void:
	#difference in a and b's velocity
	#we can use this to compensate for swapped values
	var delta_velocity : float = a.velocity - b.velocity
	
	#parallel lines
	if delta_velocity == 0.0:
		return
	
	#this gives us a normalized 1d direction, either 1.0 or -1.0
	var dir : float = delta_velocity / abs(delta_velocity)
	
	#time when object origins meet
	var object_intersection : float = (a.position - b.position) / (a.velocity - b.velocity)
	#the distance that a collision occurs between the two objects
	var s : float = a.size + b.size
	
	#time when collisions
	var plus : float = (-a.position + b.position + s) / (a.velocity - b.velocity)
	var minus : float = -((a.position - b.position + s) / (a.velocity - b.velocity))
	
	var right : float = max(plus, minus)
	var left : float = min(plus, minus)
	
	var collision_time : float
	#position when collision
	if object_intersection > 0.0:
		collision_time = right
		if collision_time < 0.0:
			return
	else:
		collision_time = left
	
	#collision doesnt happen this frame
	if collision_time > delta:
		return
	
	#this can send the object back in time per se, 
	var collision_position : float = a.position + a.velocity * collision_time
	
	
	#calculate bounce
	var average_bounce : float = (a.bounce + b.bounce) / 2.0
	var final_velocity : float
	if b.get_type() == "SimulationStaticBody":
		final_velocity = lerp(b.velocity, -a.velocity, average_bounce)
	else:
		var kinetic : float = (a.mass * a.velocity + b.mass * b.velocity) / (a.mass + b.mass)
		var elastic : float = ((a.mass - b.mass) * a.velocity + 2 * b.mass * b.velocity) / (a.mass + b.mass)
		final_velocity = lerp(kinetic, elastic, average_bounce)
	
	var final_position : float = collision_position + final_velocity * (delta - collision_time)
	
	emit_signal("on_collided", abs(final_velocity - velocity) * mass)
	
	print(a, to_collide)
	
	a.set_end_velocity(final_velocity)
	a.set_end_position(final_position)

func on_collided(force : float, collider : SimulationCollider) -> void:
	emit_signal("on_collided", force, collider)
