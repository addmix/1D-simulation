extends Node
class_name SimulationConstraint

export var node_a : NodePath setget set_node_a
func set_node_a(node : NodePath) -> void:
	node_a = node
	a = get_node(node)
export var node_b : NodePath setget set_node_b
func set_node_b(node : NodePath) -> void:
	node_b = node
	b = get_node(node)

var a : SimulationCollider
var b : SimulationCollider

export var use_3d_space : bool = false

func _solve(delta : float) -> void:
	pass
