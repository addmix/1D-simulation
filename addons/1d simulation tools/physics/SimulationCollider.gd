extends SimulationObject
class_name SimulationCollider

signal on_collided

#objects we will check collision on, in nodepaths
var to_collide : Array = []

export var friction : float = 0.0 #could be called damping
export var bounce : float = 0.0
export var mass : float = 1.0

var shape : SimulationShape

func _ready() -> void:
	var children : Array = get_children()
	
	for child in children:
		if child.get_type() == "SimulationShape":
			shape = child
			break
	
	if shape == null:
		var instance := SimulationShape.new()
		add_child(instance)
		shape = instance

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
	
	var result = a.shape.get_collision_info(a, b, delta)
	
	#no collision
	if result.size() == 0:
		return
	
	#calculate bounce
	var average_bounce : float = (a.bounce + b.bounce) / 2.0
	var final_velocity : float
	
	#if type == immovable
	if b.get_type() == "SimulationStaticBody":
		final_velocity = lerp(b.velocity, b.velocity - delta_velocity, average_bounce)
	else:
		var kinetic : float = (a.mass * a.velocity + b.mass * b.velocity) / (a.mass + b.mass)
		var elastic : float = ((a.mass - b.mass) * a.velocity + 2 * b.mass * b.velocity) / (a.mass + b.mass)
		final_velocity = lerp(kinetic, elastic, average_bounce)
	
	var final_position : float = result["position"] + final_velocity * (delta - result["time"])
	
	emit_signal("on_collided", abs(final_velocity - velocity) * mass)
	
	a.set_end_velocity(final_velocity)
	a.set_end_position(final_position)

func on_collided(force : float, collider : SimulationCollider) -> void:
	emit_signal("on_collided", force, collider)

func apply_force(force : float) -> void:
	pass

func accelerate(speed : float) -> void:
	pass
