extends Spatial
class_name SimulationShape

enum shapes {NA, SEGMENT_SHAPE, BOUND_SHAPE}
var shape : int = 0

func get_type() -> String:
	return "SimulationShape"

func get_collision_info(a, b, delta : float) -> Dictionary:
	match b.shape.shape:
		shapes.NA:
			return {}
		shapes.SEGMENT_SHAPE:
			return segment_collision(a, b, delta)
		shapes.BOUND_SHAPE:
			return bound_collision(a, b, delta)
		_:
			return {}
	
	return {}

func segment_collision(a, b, delta : float) -> Dictionary:
	return {}

func bound_collision(a, b, delta : float) -> Dictionary:
	return {}
