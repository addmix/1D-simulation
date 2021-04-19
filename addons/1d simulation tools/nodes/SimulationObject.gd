extends Node
class_name SimulationObject

var constraints : Array = []

export var position : float = 0.0
onready var end_position : float = position setget set_end_position
func set_end_position(new_position: float) -> void:
	end_position = new_position
export var velocity : float = 0.0
onready var end_velocity : float = velocity setget set_end_velocity
func set_end_velocity(new_velocity: float) -> void:
	end_velocity = new_velocity

func get_type() -> String:
	return "SimulationObject"

func _ready() -> void:
	var children : Array = get_children()
	for child in children:
		match child.get_type():
			"SimulationConstraint":
				constraints.append(child)

func _pre_step() -> void:
	pass

func _step(_delta : float) -> void:
	pass

func _solve_constraints(delta : float) -> void:
	for constraint in constraints:
		constraint._solve(delta)

func _post_step() -> void:
	position = end_position
	velocity = end_velocity


