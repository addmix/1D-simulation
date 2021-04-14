extends SimulationConstraint
class_name SimulationSpringConstraint

var rest_length : float = 1.0
var stiffness : float = 1.0
var damping : float = 0.1
var minimum_length : float = 0.0
var maximum_length : float = 0.0

func solve_constraints(delta : float) -> void:
	pass
