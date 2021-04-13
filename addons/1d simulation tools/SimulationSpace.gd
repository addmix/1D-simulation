extends Spatial
class_name SimulationSpace

var gravity := Vector3(0, -9.8, 0)

var objects := []
var colliders := []

var rigidbodies := []
var staticbodies := []

func _ready() -> void:
	var children : Array = get_children()
	for child in children:
		if child is SimulationObject:
			objects.append(child)
			if child is SimulationCollider:
				colliders.append(child)
				if child is SimulationRigidBody:
					rigidbodies.append(child)
				elif child is SimulationStaticBody:
					staticbodies.append(child)
	
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

func _step(delta : float) -> void:
	if !is_inside_tree():
		return
	
	#check collisions here
	for obj in objects:
		obj._step(delta)
	
	
	var dot : float = get_global_transform().basis.x.dot(gravity.normalized()) * gravity.length()
	for rigid in rigidbodies:
		rigid.accelerate(dot * .008)

func _post_step() -> void:
	for obj in objects:
		obj._post_step()
	
	
