extends Node
class_name SimulationShape

enum shapes {SEGMENT_SHAPE, BOUND_SHAPE, ONEWAY_SHAPE}
var shape : int = 0
var collider : SimulationCollider
export var offset : float = 0.0

#layers this object is in
export(int, LAYERS_3D_PHYSICS) var collision_layer = 1 setget set_collision_layer, get_collision_layer
#layers this object checks for collisions
export(int, LAYERS_3D_PHYSICS) var collision_mask = 1 setget set_collision_mask, get_collision_mask

func set_collision_layer(layer : int) -> void:
	collision_layer = layer

func get_collision_layer() -> int:
	return collision_layer

func set_collision_mask(mask : int) -> void:
	collision_mask = mask

func get_collision_mask() -> int:
	return collision_mask

func get_type() -> String:
	return "SimulationShape"

func get_collision_info(b) -> Dictionary:
	if b.shape == null:
		return {}
	
	match b.shape:
		shapes.SEGMENT_SHAPE:
			return segment_collision(b)
		shapes.BOUND_SHAPE:
			return bound_collision(b)
		shapes.ONEWAY_SHAPE:
			return oneway_collision(b)
		_:
			return {}
	
	return {}

func segment_collision(b) -> Dictionary:
	return {}

func bound_collision(b) -> Dictionary:
	return {}

func oneway_collision(b) -> Dictionary:
	return {}

func _pre_step() -> void:
	for child in get_children():
		if child.has_method("_pre_step"):
			child._pre_step()

func _step(delta : float) -> void:
	pass

func _post_step() -> void:
	pass
