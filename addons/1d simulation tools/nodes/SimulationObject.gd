extends Node
class_name SimulationObject

export var position : float = 0.0
onready var end_position : float = position
onready var cached_position : float = position
export var velocity : float = 0.0
onready var end_velocity : float = velocity
export var friction : float = 0.0
export var position_lock := false

var space : SimulationSpace

func get_type() -> String:
	return "SimulationObject"

func _pre_step() -> void:
	pass

func _step(delta : float) -> void:
	_solve_friction(delta)

func _post_step() -> void:
	if position_lock:
		position = cached_position
		velocity = 0


#physics


func _sub_step(delta: float) -> void:
	position += velocity * delta

func _solve_friction(delta: float) -> void:
	if velocity * friction * delta == 0:
		return
	var force : float = velocity / abs(velocity) * friction * delta
	var new_velocity : float = velocity - force
	var changed_direction : bool = (new_velocity > 0.0 and velocity <= 0.0) or (new_velocity <= 0.0 and velocity > 0.0)
	velocity = float(!changed_direction) * new_velocity
