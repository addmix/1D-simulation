extends SimulationSpaceSegment
class_name SimulationLinearSpace

export var length : float = 1.0


func _init(l : float = 1.0) -> void:
	length = l

func get_transform(i : float = 0.0) -> Transform:
	var basis := Basis(transform.basis.get_euler() + twist * i)
	return Transform(basis, basis.x * length * i) * global_transform.inverse()

func get_end_transform() -> Transform:
	return global_transform * Transform(transform.basis, transform.basis.x * length).inverse()
