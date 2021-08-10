tool
extends Spatial
class_name SimulationSpace

export var segments : Array = []

var gravity := Vector3(0, -9.8, 0)

var maximum_iterations : int = 25

var objects := []
var colliders := []

var rigidbodies := []
var staticbodies := []

var constraints := []

func get_type() -> String:
	return "SimulationSpace"

func _ready() -> void:
	if Engine.editor_hint:
		return
	
	var children : Array = get_children()
	for child in children:
		match child.get_type():
			"SimulationObject":
				objects.append(child)
				child.space = self
			"SimulationCollider":
				objects.append(child)
				colliders.append(child)
				child.space = self
			"SimulationStaticBody":
				objects.append(child)
				colliders.append(child)
				staticbodies.append(child)
				child.space = self
			"SimulationRigidBody":
				objects.append(child)
				colliders.append(child)
				rigidbodies.append(child)
				child.space = self
			"SimulationSpringConstraint":
				constraints.append(child)
				child.space = self


func _exit_tree() -> void:
	for object in objects:
		if object:
			object.queue_free()
	
	queue_free()

func _pre_step() -> void:
	for obj in objects:
		obj._pre_step()

func _step(delta : float) -> void:
	if !is_inside_tree():
		return
	
	var _delta : float = delta
	for i in maximum_iterations:
		_delta = _solve_collisions(_delta)
		if _delta == 0.0:
			break
	
#	if _delta != 0.0:
#		print("not enough iterations")
	
	for obj in objects:
		obj._step(delta)
	
	for collider in colliders:
		collider.apply_accel_buffer()

func _post_step() -> void:
	for obj in objects:
		obj._post_step()


#3d representation of 1d simulation


func create_linear() -> void:
	pass
#	segments.append(SimulationLinearSpace.new(1.0))

func create_radial() -> void:
	pass
#	segments.append(SimulationRadialSpace.new())

func get_end_transform() -> Transform:
	return get_global_transform()

func get_transform_at_pos(pos : float) -> Transform:
	var sofar : float = 0.0
	for segment in segments:
		sofar += segment.length
		#we have found the correct segment
		if sofar >= pos:
			#get 0-1 from size
			var distance_past_segment : float = pos - (sofar - segment.length)
			return segment.get_transform(distance_past_segment / segment.length)
	
	if pos <= 0.0:
		return Transform()
	elif pos >= sofar:
		return segments[-1].get_end_transform()
	else:
		return Transform()


#physics stuff


func _solve_collisions(delta : float) -> float:
	
	#get all future collisions
	var collisions : Array = []
	
	for i in colliders:
		collisions.append_array(i.get_collisions())
	
#	var relevant_collisions : Array = get_relevant_collisions(collisions)
	
	var result : Array = get_first_collision(collisions)
	
	#when no collision happens this frame
	if result[1] > delta:
		for i in colliders:
			i._sub_step(delta)
		return 0.0
	
	var collision : Dictionary = collisions[result[0]]
	#step everything
	for i in colliders:
		i._sub_step(collision["time"])
	
	#apply a and b collision
	var a = collision["a"]
	var b = collision["b"]
	
	var time_remaining : float = delta - collision["time"]
	var average_bounce : float = (a.bounce + b.bounce) / 2.0
	
	apply_collision(a, b, average_bounce, time_remaining)
	
	a.velocity = a.end_velocity
	
	return time_remaining

func get_first_collision(collisions : Array) -> Array:
	#get first collision
	#smallest time
	var smallest : float = 10000000000.0
	#index
	var index : int = -1
	
	for i in collisions.size():
		var time : float = collisions[i]["time"]
		var less : bool = time < smallest
		
		smallest = float(less) * time + float(!less) * smallest
		index = int(less) * i + int(!less) * index
	
	return [index, smallest]

func get_relevant_collisions(arr : Array) -> Array:
	#get first collision
	#smallest time
	var smallest : float = 10000000000.0
	for i in arr.size():
		var time : float = arr[i]["time"]
		var less : bool = time < smallest
		smallest = float(less) * time + float(!less) * smallest
	
	var collisions : Array = []
	
	for i in arr:
		if i["time"] == smallest:
			collisions.append(i)
	
	return collisions

func _solve_constraints(delta : float) -> void:
	for constraint in constraints:
		constraint._solve(delta)

func apply_collision(a, b, average_bounce, time_remaining) -> void:
	#static body bounce
	var static_bounce : float = lerp(b.velocity, b.velocity - (a.velocity - b.velocity), average_bounce)
	#rigid body bounce
	var rigid_kinetic : float = (a.mass * a.velocity + b.mass * b.velocity) / (a.mass + b.mass)
	var rigid_elastic : float = ((a.mass - b.mass) * a.velocity + 2 * b.mass * b.velocity) / (a.mass + b.mass)
	var rigid_bounce = lerp(rigid_kinetic, rigid_elastic, average_bounce)
	
	#branchless lerp
	var final_velocity : float = lerp(rigid_bounce, static_bounce, float(b.get_type() == "SimulationStaticBody" or b.position_lock))
	var e : bool = a.get_type() == "SimulationStaticBody"
	
	a.emit_signal("on_collided", b, abs(final_velocity - a.velocity) * a.mass, time_remaining)
	a.end_velocity = float(e) * a.velocity + float(!e) * final_velocity
