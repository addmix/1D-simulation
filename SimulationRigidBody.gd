extends SimulationCollider
class_name SimulationRigidBody

func get_type() -> String:
	return "SimulationRigidBody"

func _step(delta : float) -> void:
	._step(delta)

func _post_step() -> void:
	._post_step()

func apply_force(force : float) -> void:
	velocity += force / mass

func accelerate(speed : float) -> void:
	end_velocity += speed
