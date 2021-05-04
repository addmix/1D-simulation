extends Node
class_name SimulationShape

enum shapes {SEGMENT_SHAPE, BOUND_SHAPE, ONEWAY_SHAPE}
var shape : int = 0
var collider : SimulationCollider
export var offset : float = 0.0

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
