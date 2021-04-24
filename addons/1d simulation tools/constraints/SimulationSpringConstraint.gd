extends SimulationConstraint
class_name SimulationSpringConstraint

export var stiffness : float = 1.0
export var pre_tension : float = 1.0

func get_type() -> String:
	return "SimulationSpringConstraint"

func _solve(delta : float) -> void:
	#in simulation space
	var delta_pos : float = a.position - b.position
	a.apply_force(stiffness * -delta_pos * delta)
	b.apply_force(stiffness * delta_pos * delta)
	
