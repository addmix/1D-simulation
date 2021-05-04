extends Node

export var bolt : NodePath
export var primer : NodePath
export var sear : NodePath


var _bolt : SimulationRigidBody
var _primer : SimulationRigidBody
var _sear : SimulationOnewayShape

func _ready():
	_bolt = get_node(bolt)
#	_primer = get_node(primer)
	_sear = get_node(sear)
	
#	var _err := _primer.connect("on_collided", self, "on_collided")

func _process(delta : float) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		get_node(sear).depth = 0
	else:
		get_node(sear).depth = 1


func on_collided(node, force : float):
	print("reaction")
	_bolt.apply_force(-10)

