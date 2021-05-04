extends SimulationObject
class_name SimulationCollider

signal on_collided

#objects we will check collision on, in nodepaths
var to_collide : Dictionary = {}
var collision_shapes : Array = []
var constraints : Array = []

#layers this object is in
export(int, LAYERS_3D_PHYSICS) var collision_layer = 1 setget set_collision_layer, get_collision_layer
#layers this object checks for collisions
export(int, LAYERS_3D_PHYSICS) var collision_mask = 1 setget set_collision_mask, get_collision_mask

export var space_tangent_friction : float = 0.0 #friction when an object is pulled by a constraint in an axis not aligned with the current space
export var bounce : float = 0.0
export var mass : float = 1.0

onready var accel_buffer_mutex := Mutex.new()
var accel_buffer : float = 0.0


#overrides SimulationObject ready func
func _ready() -> void:
	var children : Array = get_children()
	
	for child in children:
		match child.get_type():
			"SimulationConstraint":
				constraints.append(child)
			"SimulationShape":
				collision_shapes.append(child)
				child.collider = self

func set_collision_layer(layer : int) -> void:
	collision_layer = layer
	space.recalculate_collision_groups = true

func get_collision_layer() -> int:
	return collision_layer

func set_collision_mask(mask : int) -> void:
	collision_mask = mask
	space.recalculate_collision_groups = true

func get_collision_mask() -> int:
	return collision_mask

#this could be cut in half with a proper algorithm
func calculate_colliders() -> void:
	to_collide = {}
	
	#this can be done better with an algorithm
	for collider in space.colliders:
		if collision_mask & collider.collision_layer:
			to_collide[collider.get_object_id()] = collider

func get_collisions() -> Array:
	#array of soonest collisions with every object
	var collisions : Array = []
	
	for key in to_collide.keys():
		var collider = to_collide[key]
		var result : Dictionary = get_object_collisions(collider)
		if result.size() > 0:
			collisions.append(result)
	
	return collisions

func get_object_collisions(b : SimulationCollider) -> Dictionary:
	var collisions : Array = []
	
	#this could be cut in half with a proper algorithm
	for x in collision_shapes:
		for y in b.collision_shapes:
			var result : Dictionary = x.get_collision_info(y)
			if result.size() > 0:
				collisions.append(result)
	
	#return soonest collision
	var time : float = INF
	var index : int = -1
	for i in collisions.size():
		var _time : float = collisions[i]["time"]
		var less : bool = _time < time
		
		time = float(less) * _time + float(!less) * time
		index = int(less) * i + int(!less) * index
	
	if index != -1:
		return collisions[index]
	else:
		return {}

func apply_force(force : float) -> void:
	pass

func accelerate(speed : float) -> void:
	pass

func apply_accel_buffer() -> void:
	pass
