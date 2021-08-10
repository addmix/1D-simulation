extends SimulationCollider
class_name SimulationRigidBody

func get_type() -> String:
	return "SimulationRigidBody"

func _sub_step(delta: float) -> void:
	._sub_step(delta)

func apply_force(force : float) -> void:
	accel_buffer_mutex.lock()
	accel_buffer += force / mass
	accel_buffer_mutex.unlock()

func accelerate(speed : float) -> void:
	accel_buffer_mutex.lock()
	accel_buffer += speed
	accel_buffer_mutex.unlock()

func apply_accel_buffer() -> void:
	accel_buffer_mutex.lock()
	velocity += accel_buffer
	accel_buffer = 0.0
	accel_buffer_mutex.unlock()

