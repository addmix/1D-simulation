extends Node
class_name SimulationShape

enum shapes {SEGMENT_SHAPE, BOUND_SHAPE, ONEWAY_SHAPE}
var shape : int = 0

func get_type() -> String:
	return "SimulationShape"

func get_collision_info(a, b, delta : float) -> Dictionary:
	if b.shape == null:
		return {}
	
	match b.shape.shape:
		shapes.SEGMENT_SHAPE:
			return segment_collision(a, b, delta)
		shapes.BOUND_SHAPE:
			return bound_collision(a, b, delta)
		shapes.ONEWAY_SHAPE:
			return oneway_collision(a, b, delta)
		_:
			return {}
	
	return {}

func segment_collision(a, b, delta : float) -> Dictionary:
	return {}

func bound_collision(a, b, delta : float) -> Dictionary:
	return {}

func oneway_collision(a, b, delta : float) -> Dictionary:
	return {}
