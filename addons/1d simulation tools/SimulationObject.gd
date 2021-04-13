extends Spatial
class_name SimulationObject

export var size : float = 1.0
onready var end_size : float = size setget set_end_size
func set_end_size(new_size: float) -> void:
	end_size = new_size
export var position : float = 0.0
onready var end_position : float = position setget set_end_position
func set_end_position(new_position: float) -> void:
	end_position = new_position
export var velocity : float = 0.0
onready var end_velocity : float = velocity setget set_end_velocity
func set_end_velocity(new_velocity: float) -> void:
	end_velocity = new_velocity
export var direction : bool = false
onready var end_direction : bool = direction setget set_end_direction
func set_end_direction(new_direction: bool) -> void:
	end_direction = new_direction

func get_type() -> String:
	return "SimulationObject"

func _step(_delta : float) -> void:
	pass

func _post_step() -> void:
	size = end_size
	position = end_position
	velocity = end_velocity
	direction = end_direction
