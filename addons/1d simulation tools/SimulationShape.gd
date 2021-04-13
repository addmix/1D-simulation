extends Spatial
class_name SimulationShape

enum shapes {NA, SEGMENT_SHAPE}
var shape : int = 0

func get_type() -> String:
	return "SimulationShape"

func get_collision_info(a, b, delta) -> Dictionary:
	match b.shape.shape:
		shapes.SEGMENT_SHAPE:
			return segment_collision(a, b, delta)
	
	return {}

func segment_collision(a, b, delta) -> Dictionary:
	return {}
