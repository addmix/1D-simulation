extends Spatial
class_name SimulationShape

enum shapes {NA, SEGMENT_SHAPE}
var shape : int = 0

func get_type() -> String:
	return "SimulationShape"

func get_collision_info(a, b, delta : float) -> Dictionary:
	match b.shape.shape:
		shapes.NA:
			return {}
		shapes.SEGMENT_SHAPE:
			return segment_collision(a, b, delta)
		_:
			return {}
	
	return {}

func segment_collision(a, b, delta) -> Dictionary:
	return {}
