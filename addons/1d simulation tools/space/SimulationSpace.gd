tool
extends Spatial
class_name SimulationSpace

export var segments : Array = []

var gravity := Vector3(0, -9.8, 0)

var objects := []
var colliders := []

var rigidbodies := []
var staticbodies := []

func _ready() -> void:
	if Engine.editor_hint:
		return
	
	var children : Array = get_children()
	for child in children:
		match child.get_type():
			"SimulationObject":
				objects.append(child)
			"SimulationCollider":
				objects.append(child)
				colliders.append(child)
			"SimulationStaticBody":
				objects.append(child)
				colliders.append(child)
				staticbodies.append(child)
			"SimulationRigidBody":
				objects.append(child)
				colliders.append(child)
				rigidbodies.append(child)
	
	var ordered : Array = order_array(colliders, "position")
	
	#tells objects what they need to collide with
	for i in ordered.size():
		if ordered[i] is SimulationStaticBody:
			continue
		elif ordered[i] is SimulationRigidBody:
			
			if i > 0:
				ordered[i].to_collide.append(ordered[i - 1].get_path())
			if !i+1 >= ordered.size():
				ordered[i].to_collide.append(ordered[i + 1].get_path())

#only works for floats and ints
func order_array(arr : Array, attribute : String) -> Array:
	var ordered_array : Array = []
	
	for i in arr.size():
		#get lowest value
		var lowest_value : float = -INF
		var lowest_value_index : int = 0
		for obj in arr.size():
			var lower : bool = arr[obj].get(attribute) <= lowest_value
			lowest_value = float(lower) * arr[obj].get(attribute) + float(not lower) * lowest_value
			lowest_value_index = int(lower) * obj + int(not lower) * lowest_value_index
		
		ordered_array.append(arr[lowest_value_index])
		arr.remove(lowest_value_index)
	
	return ordered_array

func _pre_step() -> void:
	for obj in objects:
		obj._pre_step()

func _step(delta : float) -> void:
	if !is_inside_tree():
		return
	
	#check collisions here
	for obj in objects:
		obj._step(delta)

func _solve_constraints(delta : float) -> void:
	for obj in objects:
		obj._solve_constraints(delta)

func _post_step() -> void:
	for obj in objects:
		obj._post_step()

func create_linear() -> void:
	segments.append(SimulationLinearSpace.new(1.0))

func create_radial() -> void:
	segments.append(SimulationRadialSpace.new())

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







